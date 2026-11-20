#!/usr/bin/env bash
# ==============================================================================
# Sync Google Doc "Sami — Directives Inbox" to /memory/INBOX.md (zero AI tokens)
# Requires INBOX_EXPORT_URL in untracked .env.local
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PROJECT_ROOT/.env.local"
TARGET_FILE="$PROJECT_ROOT/memory/INBOX.md"
TMP_FILE="$(mktemp)"

trap 'rm -f "$TMP_FILE"' EXIT

if [ ! -f "$ENV_FILE" ]; then
    echo "Error: Missing $ENV_FILE (define INBOX_EXPORT_URL)." >&2
    exit 1
fi

# shellcheck source=/dev/null
source "$ENV_FILE"

if [ -z "${INBOX_EXPORT_URL:-}" ]; then
    echo "Error: INBOX_EXPORT_URL is empty in $ENV_FILE." >&2
    exit 1
fi

# Fetch Google Doc as clean Markdown
curl -fsSL "$INBOX_EXPORT_URL" -o "$TMP_FILE"

# Guard: reject empty responses or HTML pages (e.g. Google login/consent screens)
if [ ! -s "$TMP_FILE" ] || head -c 512 "$TMP_FILE" | grep -qiE '<!doctype|<html'; then
    echo "Error: export did not return Markdown (check document sharing settings)." >&2
    exit 1
fi

# Update target only if content actually changed
OLD_HASH=$( [ -f "$TARGET_FILE" ] && sha256sum "$TARGET_FILE" | awk '{print $1}' || echo "none" )
NEW_HASH=$( sha256sum "$TMP_FILE" | awk '{print $1}' )

if [ "$OLD_HASH" != "$NEW_HASH" ]; then
    mv "$TMP_FILE" "$TARGET_FILE"
    echo "Updated: memory/INBOX.md has new directives."
else
    echo "No changes: memory/INBOX.md is already up to date."
fi