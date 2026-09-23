#!/usr/bin/env python3
"""Writes a static share page per published blog post into build/web.

Why this exists: link previews (WhatsApp, LinkedIn, X, Slack...) read the
<meta> tags of the HTML a URL returns and never run the Flutter app. The app
uses hash routes (/#/blog/<id>), and the part after # is never sent to the
server, so every blog link previewed as the generic home page.

Each post gets build/web/blog/<id>/index.html carrying that post's Open Graph
tags, which immediately forwards real visitors to /#/blog/<id>. The blog share
buttons link to https://<site>/blog/<id>. Posts published after the last
deploy have no page yet; web/index.html redirects /blog/<id> to the app route,
so the link still works and only the preview is generic until the next deploy.

Usage (run by build.sh after `flutter build web`):
  SUPABASE_URL=... SUPABASE_ANON_KEY=... python3 scripts/generate_blog_share_pages.py
"""

import html
import json
import os
import subprocess
import sys
from pathlib import Path

SITE_URL = "https://www.gokulks.in"
SITE_NAME = "Gokul K S"
OUT_DIR = Path(__file__).resolve().parent.parent / "build" / "web" / "blog"


def fetch_posts(supabase_url: str, anon_key: str) -> list[dict]:
    # curl rather than urllib: python.org builds on macOS ship without CA
    # certificates, while curl uses the system trust store.
    query = (
        "select=id,title,excerpt,cover_image_url,author_name,created_at"
        "&is_published=eq.true"
    )
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


def render_page(post: dict) -> str:
    post_id = str(post["id"])
    title = post.get("title") or SITE_NAME
    excerpt = post.get("excerpt") or ""
    image = post.get("cover_image_url") or ""
    author = post.get("author_name") or SITE_NAME
    share_url = f"{SITE_URL}/blog/{post_id}"
    app_url = f"/#/blog/{post_id}"

    e = lambda value: html.escape(value, quote=True)  # noqa: E731
    image_tags = (
        f'  <meta property="og:image" content="{e(image)}">\n'
        f'  <meta name="twitter:image" content="{e(image)}">\n'
        if image
        else ""
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
  <meta http-equiv="refresh" content="0; url={e(app_url)}">
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

    for post in posts:
        page_dir = OUT_DIR / str(post["id"])
        page_dir.mkdir(parents=True, exist_ok=True)
        (page_dir / "index.html").write_text(render_page(post), encoding="utf-8")

    print(f"Wrote {len(posts)} blog share page(s) to {OUT_DIR}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
