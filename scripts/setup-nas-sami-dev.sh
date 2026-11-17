#!/usr/bin/env bash
# ==============================================================================
# SAMILAB NAS SANDBOX INITIALIZATION SCRIPT (Run once as root/sudo on Ubuntu NAS)
# Purpose:
#   1. Create restricted Linux user 'sami-dev' (zero sudo privileges).
#   2. Configure SSH public key access for VS Code Remote-SSH.
#   3. Grant exclusive ownership on /var/www/samilab.
#   4. Initialize local MariaDB test database ('samilab_library_test').
#   5. Install a 15-minute cron job for automatic Git checkpoint backups.
# ==============================================================================
set -e

PROJECT_DIR="/var/www/samilab"
DEV_USER="sami-dev"
WEB_GROUP="www-data"

echo "=== 1. Creating restricted user '$DEV_USER' (no sudo privileges) ==="
if ! id "$DEV_USER" &>/dev/null; then
    sudo adduser --disabled-password --gecos "Sami AI Dev Sandbox" "$DEV_USER"
fi
sudo usermod -aG "$WEB_GROUP" "$DEV_USER"

echo "=== 2. Configuring SSH authorized_keys for '$DEV_USER' ==="
sudo mkdir -p /home/$DEV_USER/.ssh
if [ -f "$HOME/.ssh/authorized_keys" ]; then
    sudo cp "$HOME/.ssh/authorized_keys" /home/$DEV_USER/.ssh/authorized_keys
fi
sudo chown -R $DEV_USER:$DEV_USER /home/$DEV_USER/.ssh
sudo chmod 700 /home/$DEV_USER/.ssh
sudo chmod 600 /home/$DEV_USER/.ssh/authorized_keys 2>/dev/null || true

echo "=== 3. Setting directory structure and permissions on $PROJECT_DIR ==="
sudo mkdir -p "$PROJECT_DIR"/{memory,wp-plugin/sami-governance,wp-theme/samilab-pale,library/{public,src,schema,static_cache,exports},scripts}
sudo chown -R $DEV_USER:$WEB_GROUP "$PROJECT_DIR"
sudo chmod -R 2775 "$PROJECT_DIR"

echo "=== 4. Creating local MariaDB test database 'samilab_library_test' ==="
sudo mysql -e "CREATE DATABASE IF NOT EXISTS samilab_library_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'sami_local'@'localhost' IDENTIFIED BY 'sami_local_dev_2026';"
sudo mysql -e "GRANT ALL PRIVILEGES ON samilab_library_test.* TO 'sami_local'@'localhost'; FLUSH PRIVILEGES;"

echo "=== 5. Installing automated Git checkpoint cron job (every 15 minutes) ==="
sudo chmod +x "$PROJECT_DIR/scripts/auto-git-sync.sh" "$PROJECT_DIR/scripts/deploy-whc.sh" 2>/dev/null || true
CRON_JOB="*/15 * * * * $PROJECT_DIR/scripts/auto-git-sync.sh >/dev/null 2>&1"
(sudo crontab -u $DEV_USER -l 2>/dev/null | grep -v "auto-git-sync.sh"; echo "$CRON_JOB") | sudo crontab -u $DEV_USER -

echo "=============================================================================="
echo "SUCCESS: Restricted user '$DEV_USER' is ready and sandboxed in $PROJECT_DIR."
echo "It has ZERO sudo privileges and cannot modify any OS system files."
echo "=============================================================================="
