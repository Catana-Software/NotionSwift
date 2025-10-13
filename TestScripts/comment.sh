#!/usr/bin/env bash
set -euo pipefail

# Ensure NOTION_TOKEN is set in the environment
if [[ -z "${NOTION_TOKEN:-}" ]]; then
  echo "Error: NOTION_TOKEN is not set in the environment." >&2
  echo "Export it first, e.g.: export NOTION_API_KEY=\"secret_...\"" >&2
  exit 1
fi

# You can parameterize block_id via $1, default to the current hardcoded id from docs if not
# provided
BLOCK_ID="${1:-5c6a28216bb14a7eb6e1c50111515c3d}"

curl -X GET \
  "https://api.notion.com/v1/comments/${BLOCK_ID}" \
  -H "Authorization: Bearer $NOTION_TOKEN" \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Content-Type: application/json'
