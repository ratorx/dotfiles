# shellcheck shell=bash
set -euo pipefail

usage() {
  echo "usage: , [section] <page>"
  exit 1
}
trap usage EXIT

if [ "$#" -eq 1 ]; then
  page="$1"
  manargs=("$page")
elif [ "$#" -eq 2 ]; then
  page="$2"
  manargs=("$1" "$2")
else
 exit 1
fi

attr="$(nix-locate --minimal --top-level --regex -t r -t s "man/man\\d/$page\\..+" | fzf --select-1 --exit-0)"
trap - EXIT

nix shell \
  "$HOME_MANAGER_FLAKE_ROOT#man" \
  "$HOME_MANAGER_FLAKE_ROOT#gzip" \
  "$HOME_MANAGER_FLAKE_ROOT#less" \
  "$HOME_MANAGER_FLAKE_ROOT#coreutils" \
  "$HOME_MANAGER_FLAKE_ROOT#$attr" \
  -c man "${manargs[@]}"
