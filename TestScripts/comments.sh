#!/usr/bin/env bash
set -euo pipefail

# Ensure NOTION_TOKEN is set in the environment
if [[ -z "${NOTION_TOKEN:-}" ]]; then
  echo "Error: NOTION_TOKEN is not set in the environment." >&2
  echo "Export it first, e.g.: export NOTION_TOKEN=\"secret_...\"" >&2
  exit 1
fi

# Require a block_id as the first argument
if [[ $# -lt 1 || -z "${1:-}" ]]; then
  echo "Error: block_id is required as the first argument." >&2
  echo "Usage: $(basename "$0") <block_id>" >&2
  exit 1
fi

BLOCK_ID=$1

curl -sS \
  "https://api.notion.com/v1/comments?block_id=${BLOCK_ID}" \
  -H "Authorization: Bearer ${NOTION_TOKEN}" \
  -H "Notion-Version: 2022-06-28"
