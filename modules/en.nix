{ config, lib, pkgs, ... }:

{
  home.packages = lib.mkMerge [
    [
      (pkgs.custom.n)
    ]
    (lib.mkIf (!config.variants.minimal) [
      pkgs.custom.nman
      pkgs.custom.pkgfile
      pkgs.custom.pkgbin
    ])
  ];
  programs.nix-index.enable = true;
  programs.nix-index.package = pkgs.nix-index-with-db;
}
