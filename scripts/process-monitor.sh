#!/bin/bash

# process-monitor.sh
# Purpose: Monitor processes and service health
# Author: rardlous
# Usage: bash process-monitor.sh

LINE="====================="

echo "$LINE"
echo "   PROCESS MONITOR"
echo "   $(date)"
echo "$LINE"

echo ""
echo "--- Top 5 CPU Processes ---"
ps aux --sort=-%cpu | awk 'NR==1 || NR<=6' | awk 'printf "%-10s %-6s %-6s %s\n", $1, $2, $3, $11}'

echo ""
echo "--- Top 5 Memory Processes ---"
ps aux --sort=-%mem | awk 'NR==1 || NR<=6' | awk 'printf "%-10s %-6s %-6s %s\n", $1, $2, $3, $11}'

echo ""
echo "--- Critical Services ---"
for service in ssh nginx cron; do
if systemctl is-active --quiet $service; then
echo "[OK] $service is running"
else
echo "[WARN] $service is not running"
fi
done

echo ""
echo "--- Failed Units ---"
FAILED=$(systemctl list-units --state=failed --no-legend 2>/dev/null | wc -1)
if [ "$FAILED" -gt 0 ]; then
echo "[WARN] $FAILED failed unit(s) found:"
systemctl list-units --state=failed --nolegend 2>/dev/null
else
echo "[OK] No failed units"
fi

echo ""
echo "--- System Load ---"
LOAD=$(uptime | awk -F'load average:' '{print $2}' | xargs)
echo "Load average: $LOAD"
CORES=$(nproc)
echo "CPU cores: $CORES"

echo ""
echo "$LINE"
echo "   MONITOR COMPLETE"
echo "$LINE"

# Save to report logs
REPORT_FILE=~/cloud-app/logs/process-monitor-$(date +%Y%m%d-%H%M%S).log
cp /dev/stdin $REPORT_FILE 2/dev/null || true

