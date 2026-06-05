#!/bin/bash
set -euo pipefail
source ~/cloud-app/scripts/lib.sh

if [ $# -lt 1 ]; then
	echo "Usage: $0 [health|server|process|all]"
	exit 1
fi

MODE=$1

case $MODE in
	health)
	info "Running health check..."
	bash ~/cloud-app/scripts/health-check.sh
	;;
      server)
	info "Running server info..."
	bash ~/cloud-app/scripts/server-info.sh
	;;
      all)
	info "Running all checks..."
	bash ~/cloud-app/scripts/health-check.sh
	bash ~/cloud-app/scripts/server-info.sh
	bash ~/cloud-app/scripts/process-monitor.sh
	success "All checks complete"
	;;
       *)
	error "Unkown mode: $MODE"
	echo "Valid modes: health server process all"
	exit 1
	;;
esac
