# shellcheck shell=bash
if [ ! -e ./.envrc ]; then
  echo "use nix" >.envrc
  direnv allow
fi

if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
  cat >default.nix <<'EOF'
let pkgs = import <nixpkgs> {}; in
pkgs.mkShell {
  nativeBuildInputs = pkgs.lib.attrValues {
    inherit (pkgs) 
  };
}
EOF
fi