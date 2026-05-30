#!/bin/bash
# deploy-check.sh
# Purpose: Validate environment before deployment
# Author: rardlouis
# Usage: bash deploy-check.sh

ERRORS=0
LINE="===================================="
echo "$LINE"
echo "     PRE-DEPLYOMENT CHECK"
echo "$LINE"

# check required environment variables
echo ""
echo "--- Environment Variables ---"
for var in PORT NODE_ENV DB_HOST; do
if [ -z "${!var}" ]; then
echo "[FAIL] $var is not set"
ERRORS=$((ERRORS + 1))
else
echo "[OK] $var = ${!var}"
fi
done


# Check SSH service
echo ""
echo "--- Services ---"
if systemctl is-active --quiet ssh; then
echo "[OK] SSH is running"
else
echo "[FAIL] SSH is not running"
ERRORS=$((ERRORS + 1))
fi

# Check disk space
echo ""
echo "--- System Resources ---"
DISK=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
if [ "$DISK" -gt 85 ]; then
echo "[FAIL] Disk at $[DISK]% - too full to deploy safely"
ERRORS=$((ERRORS + 1))
else
echo "[OK] DIsk at ${DISK}%"
fi

# Check required directories
echo ""
echo "--- Directories ---"
for dir in ~/cloud-app/scripts ~/cloud-app/logs ~/cloud-app/config; do
if [ -d "$dir" ]; then
echo "[OK] $dir exists"
else
echo "[FAIL] $dir is missing"
ERRORS=$((ERRORS + 1))
fi
done

# Final result
echo ""
echo "$LINE"
if [ "$ERRORS" -eq 0 ]; then
echo " ALL CHECKS PASSED - ready to deploy"
else
echo " $ERRORS CHECK(S) FAILED - fix before deploying"
fi
echo "$LINE"
exit $ERRORS
