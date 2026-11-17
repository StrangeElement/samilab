#!/usr/bin/env bash
# ==============================================================================
# AUTOMATED GIT CHECKPOINT BACKUP (Executed every 15 minutes via sami-dev cron)
# ==============================================================================
cd /var/www/samilab || exit 0

if [ ! -d ".git" ]; then
    exit 0
fi

# Commit any uncommitted changes in tracked/unignored files
if [ -n "$(git status --porcelain)" ]; then
    git add -A
    git commit -m "chore(auto-checkpoint): $(date '+%Y-%m-%d %H:%M:%S')"
fi

# Push to remote repository if 'origin' is configured
if git remote | grep -q "^origin$"; then
    git push origin HEAD 2>/dev/null || true
fi
