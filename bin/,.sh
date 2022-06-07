# shellcheck shell=bash
set -euo pipefail

usage() {
  echo "usage: , <binary>"
  exit 1
}
trap usage EXIT

bin="$1"
shift

attr="$(nix-locate --minimal --top-level --whole-name -t x -t s "/bin/$bin" | fzf --select-1 --exit-0)"
trap - EXIT

nix --extra-experimental-features 'nix-command flakes' shell "$HOME_MANAGER_FLAKE_ROOT#$attr" -c "$bin" "$@"
