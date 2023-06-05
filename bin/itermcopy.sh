# shellcheck shell=bash
# clipboard provider for neovim
: "${TTY:=$( (tty || tty </proc/$PPID/fd/0) 2>/dev/null | grep /dev/)}"
[[ -n "$TTY" ]] && printf $'\033]1337;Copy=:%s\7' "$(base64)" > "$TTY"

