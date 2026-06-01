#!/bin/bash

# setup-monitoring.sh
# Puropse: Install packages and configure automated monitoring
# Author: rardlouis
# Usage: bash setup-monitoring.sh

LINE="===================================="
echo "     MONITORING SETUP"
echo "     $(date)"
echo "$LINE"


# Ensure log directory exists
echo ""
echo "--- Setting up directories ---"
mkdir -p ~/cloud-app/logs
echo "[OK] Log directory ready"

# Ensure scripts are executable
echo ""
echo "--- Setting permissions ---"
for script in ~/cloud-app/*.sh; do
chmod +x "$script"
echo "[OK] $(basename $script) is executable"
done

# Install required packages
echo ""
echo "--- Installing packages ---"
sudo apt update -qq
for pkg in htop curl tree; do
if dpkg -s $pkg > /dev/null 2>&1; then
echo "[OK] $pkg already installed"
else
sudo apt install -y $pkg > /dev/null 2>&1
echo "[INSTALLED] $pkg"
fi
done

# Set up cron jobs
echo ""
echo "--- Configuring cron jobs ---"
CRON_HEALTH="*/5 * * * * /home/rardlouis/cloud-app/scripts/health-check.sh >> /home/rardlouis/cloud-app/logs/health.log 2>&1"
CRON_DAILY="0 8 * * * /home/rardlouis/cloud-app/scripts/server-info.sh >> /home/rardlouis/cloud-app/logs/daily-report.log 2>&1"
CRON_CLEAN="0 0 * * 0 find /home/rardlouis/cloud-app/logs -name *.log -mtime +7 -delete"

(crontab -l 2>/dev/null | grep -v "health-check\|server-info\|cloud-app/logs.*delete"; \
echo "$CRON_HEALTH"; \
echo "$CRON_DAILY"; \
echo "$CRON_CLEAN") | crontab -

echo "[OK] Health check scheduled every 5 minutes"
echo "[OK] Daily report scheduled at 8 AM"
echo "[OK] Log cleanup scheduled weekly"

# Verify cron is running
echo ""
echo "--- Verifying services ---"
if systemctl is-active --quiet cron; then
echo "[OK] Cron service is running"
else
echo "[WARN] Cron is not running - starting it"
sudo systemctl start cron
fi

echo ""
echo "$LINE"
echo "   SETUP COMPLETE"
echo "   Run: crontab -l to verify jobs"
echo "$LINE"
