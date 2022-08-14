# shellcheck shell=bash
# Reauthenticate on all workstations
set -euo pipefail

/usr/local/bin/rw --cider --check_remaining --nossh_interactively kronos.lon.corp.google.com iapetus.fra.corp.google.com
