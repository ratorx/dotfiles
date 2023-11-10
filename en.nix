{ inputs, flakeRoot, pkgs, ... }:

{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];
  home.packages = [
    (pkgs.custom.builder.n flakeRoot)
    (pkgs.custom.builder.nman flakeRoot)
    pkgs.custom.pkglocate
    # This is an amazing hack that makes 'n' and 'nman' work offline if the
    # package is already present! This is necessary since there's no way for Nix
    # to track dependencies in flake inputs (as they don't usually reference
    # each other by path). Without this, all flake deps of the packages (i.e.
    # this flake) would be fetched (and cleaned up by nix-collect-garbage).
    # This WILL NOT WORK (I think) if there are dependent flakes.
    (pkgs.writeTextDir "inputs" ''
      ${builtins.toString (builtins.attrValues inputs)}
    '')
  ];
  programs.nix-index.enable = true;
}
