#!/bin/bash
set -euo pipefail


source "$(dirname "$0")/lib.sh"

TMPFILE=$(mktemp)
trap "rm -f $TMPFILE" EXIT

usage() {
	echo "Usage: $0 --action ACTION [--service SERVICE]"
	echo ""
	echo "Actions:"
	echo " health   Run health check"
	echo " logs     Analyze logs"
	echo " status   Check service status"
	echo " report   Full system report"
	echo ""
	echo "Examples:"
	echo " $0 --action health"
	echo " $0 --action status --service nginx"
	echo " $0 --action report"
}

ACTION=""
SERVICE=""

while [[ $# -gt 0 ]]; do
	case $1 in
		--action) ACTION=$2; shift 2 ;;
		--service) SERVICE=$2; shift 2 ;;
		--help) usage; exit 0 ;;
		*) error "Unknown option: $1"; usage; exit 1 ;;
	esac
done

if [ -z "$ACTION" ]; then
	error "Action is required"
	usage
	exit 1
fi

LINE="=========================================================="

case $ACTION in
	health)
		info  "Running health check . . ."
		bash ~/cloud-app/scripts/health-check.sh
		;;
	logs)
		info "Analyzing logs . . ."
		bash ~/cloud-app/scripts/log-analyzer.sh
		;;
	status)
		if [ -z "$SERVICE" ]; then
			error "Service name required for status action"
			echo "Usage: $0 --action status --service nginx"
			exit 1
		fi
		info "Checking status of $SERVICE . . ."
		if is_running "$SERVICE"; then
			success "$SERVICE is running"
			journalctl -u "$SERVICE" -n 5 --no-pager
		else
			warning "$SERVICE is not running"
			exit 1
		fi
		;;
	report)
		info "Generating full system report . . ."
		echo "$LINE"
		echo " FULL SYSTEM REPORT - $(date)"
		echo "$LINE"
		echo ""
		echo "--- Disk ---"
		DISK=$(disk_usage /)
		if [ "$DISK" -gt 80 ]; then
			warning "Disk at ${DISK}%"
		else
			success "Disk at ${DISK}%"
		fi
		echo ""
		echo "--- Memory ---"
		free -h | grep Mem
		echo ""
		echo "--- Services ---"
		for svc in ssh nginx cron; do
			if is_running "$svc"; then
				success "$svc running"
			else
				warning "$svc stopped"
			fi
		done
		echo ""
		echo "$LINE"
		success "Report complete"
		echo "$LINE"
		;;
	*)
		error "Unkown action: $ACTION"
		usage
		exit 1
		;;
esac
		
