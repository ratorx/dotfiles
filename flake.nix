{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, flake-utils, nixpkgs, home-manager, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = self.legacyPackages.${system};
        in
        {
          legacyPackages = import nixpkgs {
            inherit system;
            # config.allowUnfree = true;
            overlays = [ (import ./overlay inputs) ];
          };
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
        }) // (
      let
        homeCfgBase = {
          modules = [ ./modules/home.nix ];
          extraSpecialArgs = {
            inherit inputs;
            flakeRoot = builtins.toString ./.;
          };
        };
        makeCfg = (cfg: home-manager.lib.homeManagerConfiguration (homeCfgBase // cfg // { modules = homeCfgBase.modules ++ cfg.modules; }));
      in
      {
        homeConfigurations."reeto@zeus" = makeCfg {
          modules = [ ./zeus.nix ];
          pkgs = self.legacyPackages.${flake-utils.lib.system.x86_64-linux};
        };
        homeConfigurations."reeto@iapetus.c.googlers.com" = makeCfg {
          modules = [ ./glinux.nix ];
          pkgs = self.legacyPackages.${flake-utils.lib.system.x86_64-linux};
        };
        homeConfigurations."reeto@kronos.lon.corp.google.com" = makeCfg {
          modules = [ ./glinux.nix ];
          pkgs = self.legacyPackages.${flake-utils.lib.system.x86_64-linux};
        };
        homeConfigurations."reeto@oceanus.roam.internal" = makeCfg {
          modules = [ ./oceanus.nix ];
          pkgs = self.legacyPackages.${flake-utils.lib.system.x86_64-darwin};
        };
        homeConfigurations."reeto@poseidon" = makeCfg {
          modules = [ ./poseidon.nix ];
          pkgs = self.legacyPackages.${flake-utils.lib.system.aarch64-darwin};
        };
      }
    );
}
