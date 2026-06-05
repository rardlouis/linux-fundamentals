#!/bin/bash

info() { echo -e "\e[34m[INFO]\e[0m $1"; }
success() { echo -e "\e[32m[SUCCESS]\e[0m $1"; }
warning() { echo -e "\e[33m[WARNING]\e[0m $1"; }
error() { echo -e "\e[31m[ERROR]\e[0m $1"; }

check_command() {
	command -v "$1" >/dev/null 2>&1
}

check_file() {
	[ -f "$1" ]
}

disk_usage() {
	df -h "$1" | awk 'NR==2 {print $5}' | sed 's/%//'
}

is_running() {
	pgrep -x "$1" >/dev/null 2>&1
}
