# shellcheck shell=bash
set -euo pipefail

unset LESSOPEN # lesspipe not necessary since benchmark file is text
TMPFILE=$(mktemp -t nvim-startup.XXXXXX)
trap 'rm "$TMPFILE"' EXIT

nvim --startuptime "$TMPFILE" && less +G "$TMPFILE"
