{ config, inputs, lib, pkgs, ... }:

{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];
  home.packages = lib.mkMerge [
    [
      (pkgs.custom.n)
      # This is an amazing hack that makes 'n' and 'nman' work offline if the
      # package is already present! This is necessary since there's no way for Nix
      # to track dependencies in flake input sources (as they don't usually reference
      # each other by path). Without this, all flake deps of the packages (i.e.
      # this flake) would be fetched (and cleaned up by nix-collect-garbage).
      # This WILL NOT WORK (I think) if there are dependent flakes.
      (pkgs.writeTextDir "inputs" ''
        ${builtins.toString (builtins.attrValues inputs)}
      '')
    ]
    (lib.mkIf (!config.variants.minimal) [
      pkgs.custom.nman
      pkgs.custom.pkgfile
      pkgs.custom.pkgbin
    ])
  ];
  programs.nix-index.enable = true;
}
