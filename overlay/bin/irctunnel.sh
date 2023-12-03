# shellcheck shell=bash
# Create an SSH tunnel for Weechat IRC forwarding
set -euo pipefail

TUNNEL_PORT=9001
: "${HOST:="$1"}"

/usr/local/bin/rw --nossh_interactively --check_remaining "$HOST"
if lsof -t -i ":$TUNNEL_PORT" >/dev/null; then
  echo "Existing port forward on $TUNNEL_PORT"
  exit 1
fi
autossh -f -M 0 -N "$HOST" -L "$TUNNEL_PORT:127.0.0.1:$TUNNEL_PORT"
