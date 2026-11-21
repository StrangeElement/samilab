#!/usr/bin/env bash
# Generate OUTBOX.md at the repository root from core Sami context files

set -euo pipefail

OUT="scripts/OUTBOX.md"

{
  echo "# Sami Context Outbox ($(date -u '+%Y-%m-%d %H:%M UTC'))"
  echo ""
  echo "## Recent Commits"
  git log -n 5 --oneline 2>/dev/null || echo "No commits yet."

  for f in AGENTS.md memory/STATE.md memory/ROADMAP.md; do
    if [ -f "$f" ]; then
      echo ""
      echo "---"
      echo "## FILE: $f"
      echo ""
      cat "$f"
    fi
  done
} > "$OUT"

echo "Generated $OUT"