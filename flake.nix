{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, flake-utils, nixpkgs, home-manager, nix-index-database, ... }:
    let
      mkPkgs = (system: import nixpkgs {
        inherit system;
        # config.allowUnfree = true;
        overlays = [ nix-index-database.overlays.nix-index (import ./overlay inputs) ];
      });
    in
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = mkPkgs system;
        in
        {
          formatter = pkgs.nixpkgs-fmt;
          # Make a system-specific package for every homeConfiguration
          packages = nixpkgs.lib.attrsets.filterAttrs
            (_: v: v.system == system)
            (builtins.mapAttrs (_: cfg: cfg.activationPackage) self.homeConfigurations);
          apps.default = flake-utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "apply-config" ''
              set -x
              ${home-manager.packages.${system}.home-manager}/bin/home-manager --flake "${./.}" switch
            '';
          };
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = [ pkgs.shfmt pkgs.shellcheck pkgs.nil pkgs.nixpkgs-fmt pkgs.sumneko-lua-language-server ];
            buildInputs = [ ];
          };
        }) // {
      homeConfigurations = builtins.mapAttrs
        (_: cfg: home-manager.lib.homeManagerConfiguration (cfg // {
          modules = [ ./modules/home.nix ] ++ cfg.modules;
        }))
        {
          "reeto@zeus" = {
            modules = [ ./zeus.nix ];
            pkgs = mkPkgs flake-utils.lib.system.x86_64-linux;
          };
          "reeto@iapetus.c.googlers.com" = {
            modules = [ ./glinux.nix ];
            pkgs = mkPkgs flake-utils.lib.system.x86_64-linux;
          };
          "reeto@kronos.lon.corp.google.com" = {
            modules = [ ./glinux.nix ];
            pkgs = mkPkgs flake-utils.lib.system.x86_64-linux;
          };
          "reeto@oceanus.roam.internal" = {
            modules = [ ./oceanus.nix ];
            pkgs = mkPkgs flake-utils.lib.system.x86_64-darwin;
          };
          "reeto@poseidon" = {
            modules = [ ./poseidon.nix ];
            pkgs = mkPkgs flake-utils.lib.system.aarch64-darwin;
          };
        };
    };
}
