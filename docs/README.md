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

- The Linux file system hierarchy (/etc, var/log, /home)
- How to read system files like /proc/cpuinfo and /etc/os-release
- How pipes combine commands to produce structured output
- How bash scripts automate manual tasks

## Day 3 
##health-check.sh

A bash script that checks system health and reports OK Or WARN for each check.

**What it checks:**
- Disk usage (warns above 80%)
- Memory availability
- Service status (ssh, cron)
- Critical directory existence

**How to run:**

bash health-check.sh


**What I learned:**
 
- Linux file permissions (chmod, chown)
- Numeric permission values (755, 644, 600)
- Creating dedicated service users with no login shell
- Bash variables, if statements, and for loops
- Why apps should never run as root
- Idempotency concept
- Debugging bash scripts with bash -n




## Day 4

## deploy-check.sh
A comprehensive deployment readiness script that automates system pre-flight checks, verifies environmental isolation, evaluates hardware capacities, and ensures key path configurations are present before code release.

What it checks:
Environment Configuration: Validates that crucial runtime variables (PORT, NODE_ENV, DB_HOST) have been actively ingested into systemic memory.

Service Status: Confirms that the target system's background SSH daemon (sshd) is listening and responding on standard ports.

System Resources: Evaluates critical drive limits to prevent deployment failures from storage exhaustion (warns/fails if disk consumption exceeds 85%).

Directory Topology: Structural confirmation that the mandatory server workspace scaffolding (scripts/, logs/, config/) exists.

How to run:
Bash
**Run on clean shell environment to test isolation fallback logic**
bash ~/cloud-app/scripts/deploy-check.sh

**Manually scoop credentials from static asset file to memory**
export $(cat ~/cloud-app/.env | xargs)

**Execute again to confirm readiness state** 
bash ~/cloud-app/scripts/deploy-check.sh
What I learned:
Environment Variable Lifecycle Management:

Discovered that .env config blocks are passive structural data files; they do not automatically execute or load into process trees on system boot.

Mastered the "scoop" pattern (export $(cat .env | xargs)) to manually parse static keys from a localized, non-volatile storage asset and force ingestion into active terminal parent memory.

Implemented fallback default configurations inside shell execution chains (${VARIABLE:-fallback}) to keep script threads executionally safe when handling missing memory parameters.

Advanced SSH Networking & Configurations:

Configured local loopback mapping shortcuts inside ~/.ssh/config to safely reference complex remote network configurations and host profiles through logical human-readable nicknames (myvm, web-server, db-server).

Investigated core network topology rules—validating system bindings across global IPv4 (0.0.0.0:22) and IPv6 ([::]:22) network sockets using socket-statistics diagnostics tools (ss -tlnp | grep ssh).

Analyzed infrastructure deployment isolation workflows using secure AcceptEnv handshakes between developer endpoints and target servers.

Security & Infrastructure Controls:

Implemented absolute file boundary privacy locks utilizing restricted access masks (chmod 600) to guarantee secret storage assets are exclusively machine-readable by the host profile user account.

Integrated source control isolation mechanics using pattern boundaries (.gitignore) to prevent highly sensitive production keys or API tokens from leaking out to public tracking systems like GitHub.

Developed logic loops (for dir in ...) to evaluate system directory states, automate error tallies (ERRORS=$((ERRORS + 1))), and produce deterministic system exit values for modern CI/CD deployment pipelines.
