#!/usr/bin/env bash
# ==============================================================================
# SAMILAB NAS SANDBOX INITIALIZATION SCRIPT (run once with sudo on the Ubuntu NAS)
#
# Idempotent: safe to re-run on an existing checkout of the repository.
#
# Purpose:
#   1. Create the restricted Linux user 'sami-dev' (zero sudo privileges).
#   2. Copy the invoking admin's SSH public keys for VS Code Remote-SSH.
#   3. Apply correct ownership and permissions on /var/www/samilab
#      (directories 2775, files 664, scripts 755, secrets 600) without
#      touching the .git internals or producing Git file mode changes.
#   4. Configure Git identity/safety for 'sami-dev'.
#   5. Initialize the local MariaDB test database and least-privilege user.
#
# No cron job is installed: commits and pushes are performed only by the
# Orchestrator after its Validation Gate (see AGENTS.md, Section 4).
#
# Usage:
#   sudo GIT_NAME='Your Name' GIT_EMAIL='you@example.com' \
#        bash /var/www/samilab/scripts/setup-nas-sami-dev.sh
#   (The local test DB password defaults to "test"; set SAMI_DB_PASSWORD to
#    override it.)
# ==============================================================================
set -euo pipefail

PROJECT_DIR="/var/www/samilab"
DEV_USER="sami-dev"
WEB_GROUP="www-data"
DB_NAME="samilab_library_test"
DB_USER="sami_local"

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: run this script with sudo." >&2
    exit 1
fi

if [ ! -d "$PROJECT_DIR/.git" ]; then
    echo "Error: $PROJECT_DIR is not a Git checkout. Clone the repository first." >&2
    exit 1
fi

echo "=== 1. Restricted user '$DEV_USER' (no sudo privileges) ==="
if ! id "$DEV_USER" &>/dev/null; then
    adduser --disabled-password --gecos "Sami AI Dev Sandbox" "$DEV_USER"
fi
usermod -aG "$WEB_GROUP" "$DEV_USER"

echo "=== 2. SSH authorized_keys for '$DEV_USER' ==="
ADMIN_USER="${SUDO_USER:-}"
ADMIN_HOME=""
if [ -n "$ADMIN_USER" ] && [ "$ADMIN_USER" != "root" ]; then
    ADMIN_HOME="$(getent passwd "$ADMIN_USER" | cut -d: -f6)"
fi
DEV_SSH="/home/$DEV_USER/.ssh"
install -d -m 700 -o "$DEV_USER" -g "$DEV_USER" "$DEV_SSH"
if [ -n "$ADMIN_HOME" ] && [ -f "$ADMIN_HOME/.ssh/authorized_keys" ]; then
    touch "$DEV_SSH/authorized_keys"
    # Merge keys without duplicating existing entries.
    sort -u "$DEV_SSH/authorized_keys" "$ADMIN_HOME/.ssh/authorized_keys" -o "$DEV_SSH/authorized_keys"
    chown "$DEV_USER:$DEV_USER" "$DEV_SSH/authorized_keys"
    chmod 600 "$DEV_SSH/authorized_keys"
else
    echo "Warning: no authorized_keys found for the invoking admin; add keys to $DEV_SSH manually."
fi

echo "=== 3. Ownership and permissions on $PROJECT_DIR ==="
mkdir -p "$PROJECT_DIR"/library/{public,src,schema,static_cache,exports}
chown -R "$DEV_USER:$WEB_GROUP" "$PROJECT_DIR"
# Directories: setgid so new files inherit the web group.
find "$PROJECT_DIR" -path "$PROJECT_DIR/.git" -prune -o -type d -exec chmod 2775 {} +
# Regular files: never executable by default (keeps Git modes clean).
find "$PROJECT_DIR" -path "$PROJECT_DIR/.git" -prune -o -type f -exec chmod 664 {} +
# Shell scripts: executable.
find "$PROJECT_DIR/scripts" -maxdepth 1 -type f -name '*.sh' -exec chmod 755 {} +
# Local secrets: owner-only (config.local.php must be readable by the web server).
for secret in "$PROJECT_DIR/.env.local" "$PROJECT_DIR/.env.deploy" "$PROJECT_DIR/.env"; do
    [ -f "$secret" ] && chmod 600 "$secret"
done
for secret in "$PROJECT_DIR/library/config.local.php" "$PROJECT_DIR/wp-plugin/sami-governance/config.local.php"; do
    [ -f "$secret" ] && chmod 640 "$secret"
done

echo "=== 4. Git configuration for '$DEV_USER' ==="
sudo -u "$DEV_USER" git config --global --add safe.directory "$PROJECT_DIR" 2>/dev/null || true
sudo -u "$DEV_USER" git -C "$PROJECT_DIR" config core.fileMode true
if [ -n "${GIT_NAME:-}" ] && [ -n "${GIT_EMAIL:-}" ]; then
    sudo -u "$DEV_USER" git config --global user.name "$GIT_NAME"
    sudo -u "$DEV_USER" git config --global user.email "$GIT_EMAIL"
else
    echo "Warning: GIT_NAME/GIT_EMAIL not provided; configure them later as '$DEV_USER'."
fi

echo "=== 5. Local MariaDB test database '$DB_NAME' ==="
# Test-server convention (AGENTS.md, Section 3): the local NAS test database
# password defaults to "test". Override with SAMI_DB_PASSWORD if needed.
SAMI_DB_PASSWORD="${SAMI_DB_PASSWORD:-test}"
if [[ "$SAMI_DB_PASSWORD" == *"'"* || "$SAMI_DB_PASSWORD" == *"\\"* ]]; then
    echo "Error: SAMI_DB_PASSWORD must not contain quotes or backslashes." >&2
    exit 1
fi
mysql <<SQL
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$SAMI_DB_PASSWORD';
CREATE USER IF NOT EXISTS '$DB_USER'@'127.0.0.1' IDENTIFIED BY '$SAMI_DB_PASSWORD';
ALTER USER '$DB_USER'@'localhost' IDENTIFIED BY '$SAMI_DB_PASSWORD';
ALTER USER '$DB_USER'@'127.0.0.1' IDENTIFIED BY '$SAMI_DB_PASSWORD';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'127.0.0.1';
FLUSH PRIVILEGES;
SQL

echo "=== 6. Removing legacy auto-git-sync cron job (if any) ==="
if crontab -u "$DEV_USER" -l &>/dev/null; then
    (crontab -u "$DEV_USER" -l | grep -v "auto-git-sync.sh" || true) | crontab -u "$DEV_USER" -
fi

echo "=============================================================================="
echo "SUCCESS: '$DEV_USER' is ready and sandboxed in $PROJECT_DIR (zero sudo)."
echo "Next: copy .env.local.example -> .env.local and library/config.example.php"
echo "      -> library/config.local.php (as $DEV_USER), then re-run this script"
echo "      to tighten secret file permissions."
echo "=============================================================================="
