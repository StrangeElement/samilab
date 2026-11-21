#!/usr/bin/env bash
# Quick zero-token status and safety check for the Sami repository

set -euo pipefail

echo "=== 1. GIT STATUS ==="
git status -sb

echo ""
echo "=== 2. SECURITY CHECK (tracked sensitive files) ==="
SENSITIVE=$(git ls-files | grep -E '(\.env|id_ed25519|\.pem|\.key)' || true)
if [ -z "$SENSITIVE" ]; then
  echo "OK: No sensitive files tracked."
else
  echo "WARNING: Sensitive files tracked:"
  echo "$SENSITIVE"
fi

echo ""
echo "=== 3. PENDING INBOX DIRECTIVES ==="
grep -E '^## \*\*\\?\[ID:' memory/INBOX.md || echo "No IDs found in memory/INBOX.md"

echo ""
echo "=== 4. LAST LINES OF memory/STATE.md ==="
tail -n 15 memory/STATE.md