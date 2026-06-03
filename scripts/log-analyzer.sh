#!/bin/bash

# log-analyzer.sh
# Purpse: Analyze system and application logs
# Author: rardlouis
# Usage: bash log-analyzer.sh

LINE="================================================"
DATE=$(date +%Y-%m-%d)
REPORT=~/cloud-app/logs/analysis-$DATE.txt

analyze() {
echo "" | tee -a $REPORT
echo "$LINE" | tee -a $REPORT
echo " $1" | tee -a $REPORT
echo "$LINE" | tee -a $REPORT
}

echo "$LINE" | tee $REPORT
echo " LOG ANALYSIS REPORT" | tee -a $REPORT
echo " $(date)" | tee -a $REPORT
echo "$LINE" | tee -a $REPORT

# System errors in last 100 lines of syslog
analyze "SYSTEM ERRORS (last 100 syslog lines)"
sudo grep -i "error\|failed\|critical" /var/log/syslog 2>/dev/null | \
tail -100 | wc -l | xargs -I {} echo "Total error lines: {}" | tee -a $REPORT
sudo grep -i "error\|failed\|critical" /var/log/syslog 2>/dev/null | \
tail -5 | tee -a $REPORT

# Auth log summary
analyze "AUTH LOG SUMMMARY"
FAILED=$(sudo grep -c "FAILED password" /var/log/auth.log 2>/dev/null || echo 0)
SUCCESS=$(sudo grep -c "Accepted" /var/log/auth.log 2>/dev/null || echo 0)
echo "Failed login attempts : $Failed" | tee -a $REPORT
echo "Succesful logins      : $SUCCESS" | tee -a $REPORT

# Health check summary
analyze "HEALTH CHECK SUMMARY"
if [ -f ~/cloud-app/logs/health.log ]; then
RUN=$(grep -c "HEALTH CHECK" ~/cloud-app/logs/health.log || echo 0)
OKS=$(grep -c "\[OK\]" ~/cloud-app/logs/health.log || echo 0)
WARNS=$(grep -c "[WARN\]" ~/cloud-app/logs/health.log || echo 0)
echo "Total runs : $RUNS" | tee -a $REPORT
echo "OK checks  : $OKS" | tee -a $REPORT
echo "Warnings   : $WARNS" | tee -a $REPORT
echo "Top warnings:" | tee -a $REPORT
grep "\[WARN\]" ~/cloud-app/logs/health.log | \
sort | uniq -c | sort -rn | head -3 | tee -a $REPORT
else
echo "No health log found" | tee -a $REPORT
fi

# Nginx access log summary
analyze "NGINX ACCESS LOG SUMMARY"
if [ -f /var/log/nginx/access.log ]; then
TOTAL=$(sudo wc -l  /var/log/nginx/access.log | awk '{print $1}')
echo "Total requests: $TOTAL" |tee -a $REPORT
echo "Status codes:" | tee -a $REPORT
sudo awk '{print $9}' /var/log/nginx/access.log | \
sort | uniq -c | sort -rn | tee -a $REPORT
else
echo "Nginx access log out found" | tee -a $REPORT
fi

# Disk usage
analyze "LOG FILE SIZES"
du -sh ~/cloud-app/logs/* 2>/dev/null | tee -a $REPORT
du -sh ~/var/log/syslog /var/log/auth.log 2>/dev/null | tee -a $REPORT

echo "" | tee -a $REPORT
echo "$LINE" | tee -a $REPORT
echo " REPORT SAVED TO: $REPORT" | tee -a $REPORT
echo "$LINE" | tee -a $REPORT
