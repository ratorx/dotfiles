# shellcheck shell=bash
# 
set -eu

# shellcheck disable=SC2015
find ~/.sso/cookie -mmin -1200 2>/dev/null && gcertstatus --check_remaining=1h --nocheck_loas2 --quiet || gcert --noloas2
