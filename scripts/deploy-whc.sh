#!/usr/bin/env bash
# ==============================================================================
# TARGETED PRODUCTION DEPLOYMENT SCRIPT TO WHC PRO (RSYNC OVER SSH PORT 27)
# Loads server credentials from untracked .env.deploy file (zero secrets in Git)
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PROJECT_ROOT/.env.deploy"

if [ ! -f "$ENV_FILE" ]; then
    echo "Error: Missing $ENV_FILE file."
    echo "Copy .env.deploy.example to .env.deploy and fill in WHC_USER and WHC_HOST."
    exit 1
fi

# shellcheck source=/dev/null
source "$ENV_FILE"

if [ -z "$WHC_USER" ] || [ -z "$WHC_HOST" ]; then
    echo "Error: WHC_USER and WHC_HOST must be set in .env.deploy"
    exit 1
fi

WHC_PORT="${WHC_PORT:-27}"

echo "Deploying WordPress micro-plugin (sami-governance)..."
rsync -avz --exclude 'config.local.php' -e "ssh -p $WHC_PORT" "$PROJECT_ROOT/wp-plugin/sami-governance/" "$WHC_USER@$WHC_HOST:~/public_html/wp-content/plugins/sami-governance/"

echo "Deploying WordPress theme (samilab-pale)..."
rsync -avz -e "ssh -p $WHC_PORT" "$PROJECT_ROOT/wp-theme/samilab-pale/" "$WHC_USER@$WHC_HOST:~/public_html/wp-content/themes/samilab-pale/"

echo "Deploying Scientific Library PHP 8.3 app (library.samilab.io)..."
rsync -avz --exclude '.env' --exclude 'config.local.php' --exclude 'static_cache/*' --exclude 'exports/*' --exclude '*.secrets' -e "ssh -p $WHC_PORT" "$PROJECT_ROOT/library/" "$WHC_USER@$WHC_HOST:~/library.samilab.io/"

echo "Deployment completed successfully."
