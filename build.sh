#!/usr/bin/env bash
#
# Builds the Flutter web bundle with all required --dart-define values baked in.
#
# Why this exists: SUPABASE_URL / SUPABASE_ANON_KEY are read at COMPILE time via
# String.fromEnvironment (see lib/core/supabase/supabase_bootstrap.dart). A plain
# `flutter build web` omits them, so the deployed site can't read the Supabase
# `app_projects` table and renders no projects. Always build through this script.
#
# Credentials are loaded from a local, git-ignored `.env` file. Copy `.env.example`
# to `.env` and fill in the values. They can also be supplied as real environment
# variables (CI), which take precedence over `.env`.
#
# Usage:
#   ./build.sh                 # release build into build/web
#   ./build.sh --profile       # pass extra flags straight through to flutter

set -euo pipefail

cd "$(dirname "$0")"

# ── Load .env if present (does not override already-exported env vars) ──────────
if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

# ── Validate required defines ──────────────────────────────────────────────────
missing=()
[[ -z "${SUPABASE_URL:-}" ]] && missing+=("SUPABASE_URL")
[[ -z "${SUPABASE_ANON_KEY:-}" ]] && missing+=("SUPABASE_ANON_KEY")

if (( ${#missing[@]} > 0 )); then
  echo "ERROR: missing required value(s): ${missing[*]}" >&2
  echo "       Set them in a .env file (see .env.example) or export them." >&2
  exit 1
fi

# Reject the .env.example placeholders so a half-finished setup can't ship.
if [[ "${SUPABASE_URL}" == *"YOUR_PROJECT"* || "${SUPABASE_ANON_KEY}" == "YOUR_ANON_KEY" ]]; then
  echo "ERROR: .env still contains placeholder values from .env.example." >&2
  echo "       Edit .env and set your real SUPABASE_URL and SUPABASE_ANON_KEY." >&2
  exit 1
fi

echo "Building web bundle with Supabase config baked in (${SUPABASE_URL})"

flutter build web --release \
  --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}" \
  "$@"

echo "Done. Output in build/web — deploy with: firebase deploy --only hosting"
