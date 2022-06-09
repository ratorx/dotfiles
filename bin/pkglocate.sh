# shellcheck shell=bash
nix-locate --minimal --top-level --whole-name "$1" | sed 's/\.out$//'