#!/usr/bin/env python3
"""Writes a static share page per published blog post into build/web.

Why this exists: link previews (WhatsApp, LinkedIn, X, Slack...) read the
<meta> tags of the HTML a URL returns and never run the Flutter app. The app
uses hash routes (/#/blog/<id>), and the part after # is never sent to the
server, so every blog link previewed as the generic home page.

Each post gets build/web/blog/<id>.html (served at /blog/<id> via Firebase
cleanUrls, with no redirect) carrying that post's Open Graph tags. A script
forwards real visitors to /#/blog/<id>; there is deliberately no
<meta http-equiv="refresh">, because link-preview crawlers follow it to the
app's index.html and read the generic site tags instead. The blog share
buttons link to https://www.gokulks.in/blog/<id>. Posts published after the last
deploy have no page yet; web/index.html redirects /blog/<id> to the app route,
so the link still works and only the preview is generic until the next deploy.

Usage (run by build.sh after `flutter build web`):
  SUPABASE_URL=... SUPABASE_ANON_KEY=... python3 scripts/generate_blog_share_pages.py
"""

import html
import json
import os
import shutil
import struct
import subprocess
import sys
from pathlib import Path

SITE_URL = "https://www.gokulks.in"
SITE_NAME = "Gokul K S"
OUT_DIR = Path(__file__).resolve().parent.parent / "build" / "web" / "blog"


def fetch_posts(supabase_url: str, anon_key: str) -> list[dict]:
    # curl rather than urllib: python.org builds on macOS ship without CA
    # certificates, while curl uses the system trust store.
    # select=* rather than a column list, so this keeps working on a
    # database that hasn't added the newer optional columns (external_url).
    query = "select=*&is_published=eq.true"
    result = subprocess.run(
        [
            "curl", "--silent", "--show-error", "--fail", "--max-time", "30",
            "-H", f"apikey: {anon_key}",
            "-H", f"Authorization: Bearer {anon_key}",
            f"{supabase_url.rstrip('/')}/rest/v1/blog_posts?{query}",
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    return json.loads(result.stdout)


def image_size(url: str) -> tuple[int, int] | None:
    """(width, height) of a JPEG/PNG/WebP image, or None if unknown.

    Declaring og:image:width/height lets WhatsApp and Facebook render the
    large image card on first share instead of a small thumbnail.
    """
    try:
        data = subprocess.run(
            ["curl", "--silent", "--fail", "--max-time", "30", url],
            check=True,
            capture_output=True,
        ).stdout
    except subprocess.CalledProcessError:
        return None

    if data[:8] == b"\x89PNG\r\n\x1a\n":
        return struct.unpack(">II", data[16:24])
    if data[:4] == b"RIFF" and data[8:12] == b"WEBP":
        chunk = data[12:16]
        if chunk == b"VP8X":
            w = int.from_bytes(data[24:27], "little") + 1
            h = int.from_bytes(data[27:30], "little") + 1
            return w, h
        if chunk == b"VP8 ":
            w, h = struct.unpack("<HH", data[26:30])
            return w & 0x3FFF, h & 0x3FFF
        if chunk == b"VP8L":
            bits = int.from_bytes(data[21:25], "little")
            return (bits & 0x3FFF) + 1, ((bits >> 14) & 0x3FFF) + 1
        return None
    if data[:2] == b"\xff\xd8":
        i = 2
        while i + 9 < len(data):
            if data[i] != 0xFF:
                i += 1
                continue
            marker = data[i + 1]
            length = struct.unpack(">H", data[i + 2 : i + 4])[0]
            if marker in (0xC0, 0xC1, 0xC2):
                h, w = struct.unpack(">HH", data[i + 5 : i + 9])
                return w, h
            i += 2 + length
    return None


def image_type(url: str) -> str:
    lower = url.lower().split("?")[0]
    if lower.endswith(".png"):
        return "image/png"
    if lower.endswith(".webp"):
        return "image/webp"
    return "image/jpeg"


def render_page(post: dict) -> str:
    post_id = str(post["id"])
    title = post.get("title") or SITE_NAME
    excerpt = post.get("excerpt") or ""
    image = post.get("cover_image_url") or ""
    author = post.get("author_name") or SITE_NAME
    share_url = f"{SITE_URL}/blog/{post_id}"
    # Posts published elsewhere (Medium, LinkedIn...) forward to the original.
    app_url = post.get("external_url") or f"/#/blog/{post_id}"

    e = lambda value: html.escape(value, quote=True)  # noqa: E731
    image_tags = ""
    if image:
        image_tags = (
            f'  <meta property="og:image" content="{e(image)}">\n'
            f'  <meta property="og:image:secure_url" content="{e(image)}">\n'
            f'  <meta property="og:image:type" content="{image_type(image)}">\n'
            f'  <meta property="og:image:alt" content="{e(title)}">\n'
            f'  <meta name="twitter:image" content="{e(image)}">\n'
        )
        size = image_size(image)
        if size:
            image_tags += (
                f'  <meta property="og:image:width" content="{size[0]}">\n'
                f'  <meta property="og:image:height" content="{size[1]}">\n'
            )

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>{e(title)} | {e(SITE_NAME)}</title>
  <meta name="description" content="{e(excerpt)}">
  <meta name="author" content="{e(author)}">
  <link rel="canonical" href="{e(share_url)}">
  <meta property="og:type" content="article">
  <meta property="og:site_name" content="{e(SITE_NAME)}">
  <meta property="og:title" content="{e(title)}">
  <meta property="og:description" content="{e(excerpt)}">
  <meta property="og:url" content="{e(share_url)}">
{image_tags}  <meta property="article:published_time" content="{e(post.get("created_at") or "")}">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="{e(title)}">
  <meta name="twitter:description" content="{e(excerpt)}">
  <script>location.replace({json.dumps(app_url)});</script>
</head>
<body>
  <p><a href="{e(app_url)}">{e(title)}</a></p>
</body>
</html>
"""


def main() -> int:
    supabase_url = os.environ.get("SUPABASE_URL", "")
    anon_key = os.environ.get("SUPABASE_ANON_KEY", "")
    if not supabase_url or not anon_key:
        print("ERROR: SUPABASE_URL and SUPABASE_ANON_KEY are required.", file=sys.stderr)
        return 1

    try:
        posts = fetch_posts(supabase_url, anon_key)
    except Exception as error:  # noqa: BLE001 — never fail the whole build
        print(f"WARN: could not fetch blog posts, skipping share pages: {error}", file=sys.stderr)
        return 0

    # Start clean so pages for unpublished/deleted posts don't linger.
    shutil.rmtree(OUT_DIR, ignore_errors=True)
    OUT_DIR.mkdir(parents=True)
    for post in posts:
        page = OUT_DIR / f"{post['id']}.html"
        page.write_text(render_page(post), encoding="utf-8")

    print(f"Wrote {len(posts)} blog share page(s) to {OUT_DIR}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
