#!/usr/bin/env bash
# Publish a blog post draft to GoHighLevel
#
# Usage:
#   ./publish/ghl-blog.sh --discover                       # list your blog sites and their IDs
#   ./publish/ghl-blog.sh <draft.html|draft.md>            # create post as DRAFT
#   ./publish/ghl-blog.sh <draft.html> --publish           # create post as PUBLISHED
#   ./publish/ghl-blog.sh <draft.html> --title "My Title"  # override auto-detected title
#
# Required env vars (set in Claude Code web → Session → Environment):
#   GHL_API_KEY       Your Private Integration Token (pit-...) or Bearer token
#   GHL_LOCATION_ID   Your location ID  →  from URL: app.gohighlevel.com/location/<ID>/...
#   GHL_BLOG_ID       Blog site ID      →  run --discover to find it

set -euo pipefail

GHL_BASE="https://services.leadconnectorhq.com"
GHL_VERSION="2021-07-28"

# ── helpers ───────────────────────────────────────────────────────────────────

die()  { echo "ERROR: $*" >&2; exit 1; }
info() { echo "→ $*"; }

require_env() {
  [ -n "${!1:-}" ] || die "$1 is not set. Add it to your Claude Code session environment."
}

ghl_curl() {
  curl -s -f \
    -H "Authorization: Bearer $GHL_API_KEY" \
    -H "Version: $GHL_VERSION" \
    -H "Content-Type: application/json" \
    "$@"
}

# ── --discover: list all blog sites ──────────────────────────────────────────

if [[ "${1:-}" == "--discover" ]]; then
  require_env GHL_API_KEY
  require_env GHL_LOCATION_ID
  info "Fetching blogs for location $GHL_LOCATION_ID ..."
  ghl_curl "$GHL_BASE/blogs?locationId=$GHL_LOCATION_ID" \
    | jq -r '.blogs[] | "  \(.id)  →  \(.name)  (\(.url // "no url"))"'
  echo ""
  echo "Set GHL_BLOG_ID to the ID you want to publish to."
  exit 0
fi

# ── parse args ────────────────────────────────────────────────────────────────

DRAFT_FILE=""
STATUS="DRAFT"
TITLE_OVERRIDE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --publish)       STATUS="PUBLISHED" ;;
    --title)         shift; TITLE_OVERRIDE="$1" ;;
    --title=*)       TITLE_OVERRIDE="${1#--title=}" ;;
    -*)              die "Unknown flag: $1" ;;
    *)               DRAFT_FILE="$1" ;;
  esac
  shift
done

[[ -n "$DRAFT_FILE" ]] || die "Usage: $0 <draft-file> [--publish] [--title 'My Title']"
[[ -f "$DRAFT_FILE" ]] || die "File not found: $DRAFT_FILE"

require_env GHL_API_KEY
require_env GHL_LOCATION_ID
require_env GHL_BLOG_ID

# ── derive title + slug ───────────────────────────────────────────────────────

BASENAME=$(basename "$DRAFT_FILE")
NOEXT="${BASENAME%.*}"

# Strip leading date (2026-05-29-) from filename
SLUG=$(echo "$NOEXT" | sed 's/^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}-//')

if [[ -n "$TITLE_OVERRIDE" ]]; then
  TITLE="$TITLE_OVERRIDE"
elif [[ "$DRAFT_FILE" == *.html ]]; then
  # Try to extract <h1> or <title> from the HTML
  TITLE=$(grep -oP '(?<=<h1[^>]*>)[^<]+' "$DRAFT_FILE" | head -1 || true)
  [[ -z "$TITLE" ]] && TITLE=$(grep -oP '(?<=<title>)[^<]+' "$DRAFT_FILE" | head -1 || true)
  # Fall back to slug → title case
  [[ -z "$TITLE" ]] && TITLE=$(echo "$SLUG" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}')
else
  # For .md: try to read the first # heading
  TITLE=$(grep -m1 '^# ' "$DRAFT_FILE" | sed 's/^# //' || true)
  [[ -z "$TITLE" ]] && TITLE=$(echo "$SLUG" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}')
fi

# ── build HTML content ────────────────────────────────────────────────────────

if [[ "$DRAFT_FILE" == *.html ]]; then
  # Extract just the <body> content if present, otherwise use full file
  if grep -qi '<body' "$DRAFT_FILE"; then
    RAW_HTML=$(sed -n '/<body/,/<\/body>/p' "$DRAFT_FILE" | sed '1s/.*<body[^>]*>//; $s/<\/body>.*//')
  else
    RAW_HTML=$(cat "$DRAFT_FILE")
  fi
elif [[ "$DRAFT_FILE" == *.md ]]; then
  # Basic markdown → HTML: wrap in div, convert headings, paragraphs
  # For full fidelity, install pandoc: sudo apt-get install pandoc
  if command -v pandoc &>/dev/null; then
    RAW_HTML=$(pandoc -f markdown -t html "$DRAFT_FILE")
  else
    echo "NOTE: pandoc not found. Wrapping markdown in <pre> block. Install pandoc for proper HTML conversion."
    MD_CONTENT=$(cat "$DRAFT_FILE")
    RAW_HTML="<pre>${MD_CONTENT}</pre>"
  fi
else
  die "Unsupported file type. Provide a .html or .md file."
fi

# ── post to GHL ───────────────────────────────────────────────────────────────

PAYLOAD=$(jq -n \
  --arg locationId "$GHL_LOCATION_ID" \
  --arg blogId     "$GHL_BLOG_ID" \
  --arg title      "$TITLE" \
  --arg rawHTML    "$RAW_HTML" \
  --arg status     "$STATUS" \
  --arg slug       "$SLUG" \
  '{
    locationId: $locationId,
    blogId:     $blogId,
    title:      $title,
    rawHTML:    $rawHTML,
    status:     $status,
    slug:       $slug
  }')

info "Posting '$TITLE' (slug: $SLUG) as $STATUS ..."

RESPONSE=$(ghl_curl \
  -X POST "$GHL_BASE/blogs/posts" \
  -d "$PAYLOAD")

echo "$RESPONSE" | jq '{
  id:     .id,
  title:  .title,
  status: .status,
  slug:   .slug,
  url:    .url
}'

echo ""
info "Done. Status: $STATUS"
