# shellcheck shell=bash
# 
set -eu

# Check if running recursively
[ -z "${MAYBE_GCERT+x}" ] && export MAYBE_GCERT=1 || exit 0

# shellcheck disable=SC2015
/usr/local/bin/rw --no_multiplexing --nossh_interactively --check_remaining "$@"
