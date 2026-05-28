#!/bin/bash

LINE="----------------------------"

section() {
echo ""
echo "$LINE"
echo " $1"
echo "$LINE"
}

echo "==========================="
echo " SERVER INFORMATION REPORT "
echo "==========================="
echo "Date   : $(date)"
echo "Hostname : $(hostname)"
echo "User     : $(whoami)"

section "Operating System"
cat /etc/os-release | grep NAME
echo "Kernel   : $(uname -r)"
echo "Uptime   : $(uptime -p)"

section "Hardware"
echo "CPU Cores :$(nproc)"

section "Memory"
free -h

section "Disk Usage"
df -h | grep -v tmpfs

section "Recent Errors"
sudo grep -i error /var/log/syslog 2>/dev/null | tail -5

section "Network"
ip addr show | grep inet | grep -v inet6

section "Directory sizes"
du -sh /home /etc /var/log /tmp 2>/dev/null

echo ""
echo "=============================="
echo "     REPORT COMPLETE          "
echo "=============================="
