# Linux Fundamentals - Day 2

## server-info.sh

A shell script that generates a system overview report for any Linux server.

**What it reports:**

- OS version and Kernel
- CPU and memory usage
- Disk Usage per partition
- Largest log files
- Recent System errors
- Network Interfaces


**How to run:**
chmod +x server-info.sh
./server-info.sh

**WHAT I LEARNED:**

-The Linux file system hierarchy (/etc, var/log, /home)
-How to read system files like /proc/cpuinfo and /etc/os-release
-How pipes combine commands to produce structured output
-How bash scripts automate manual tasks

## Day 3 - health-check.sh

A bash script that checks system health and reports OK Or WARN for each check.

**What it checks:**
-Disk usage (warns above 80%)
-Memory availability
-Service status (ssh, cron)
-Critical directory existence

**How to run:**
bash health-check.sh


**What I learned:** 
-Linux file permissions (chmod, chown)
-Numeric permission values (755, 644, 600)
-Creating dedicated service users with no login shell
-Bash variables, if statements, and for loops
-Why apps should never run as root
-Idempotency concept
-Debugging bash scripts with bash -n
