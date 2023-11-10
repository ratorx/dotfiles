# shellcheck shell=bash
# Reauthenticate on all workstations
set -euo pipefail

/usr/local/bin/rw --check_remaining --nossh_interactively iapetus
