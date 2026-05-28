#!/bin/bash

#health-check.sh
#Purpose: Check system health and report status
#Author: rardlouis
#usage: bash health-check.sh

LINE="============================="

echo "$LINE"
echo "  SYSTEM HEALTH CHECK"
echo " $(date) "
echo "$LINE"

# Disk check
DISK=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
if [ "$DISK" -gt 80 ]; then
echo "[WARN] Disk at ${DISK}% - consider cleanup"
else
echo "[OK] Disk at ${DISK}%"
fi

# Memory check
MEM_FREE=$(free | grep Mem | awk '{print $4}')
if [ "$MEM_FREE" -lt 200000 ]; then
echo "[WARN] Low memory: ${MEM_FREE}KB free"
else
echo "[OK] Memory healthy: ${MEM_FREE}KB free"
fi

# Service Checks
for service in ssh cron; do
if systemctl is-active --quiet $service; then
echo "[OK] $service is running"
else
echo "[WARN] $service is not running"
fi

done

# Directory checks
for dir in /etc /var/log /home /tmp; do
if [ -d "$dir" ]; then
echo "[OK] $dir exist"
else
echo "[WARN] $dir missing"
fi
done

echo "$LINE"
echo " COMPLETE"
echo "$LINE"
