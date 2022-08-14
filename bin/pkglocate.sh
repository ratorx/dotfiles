# shellcheck shell=bash
# Find all Nix Packages that provide a file.
nix-locate --minimal --top-level --whole-name "$1" | sed 's/\.out$//'
