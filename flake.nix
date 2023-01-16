{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    autofix-vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      flake = false;
    };
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
            overlays = [ (import ./overlay.nix inputs) ];
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
          extraSpecialArgs = {
            inherit inputs;
            flakeRoot = builtins.toString ./.;
          };
        };
        makeCfg = (cfg: home-manager.lib.homeManagerConfiguration (homeCfgBase // cfg));
      in
      {
        homeConfigurations."reeto@zeus" = makeCfg rec {
          modules = [ ./systems/zeus.nix ];
          pkgs = self.legacyPackages.${flake-utils.lib.system.x86_64-linux};
        };
        homeConfigurations."reeto@hades" = makeCfg rec {
          modules = [ ./base.nix ];
          pkgs = self.legacyPackages.${flake-utils.lib.system.x86_64-linux};
        };
        homeConfigurations."reeto@oceanus.roam.corp.google.com" = makeCfg rec {
          modules = [ ./systems/oceanus.nix ];
          pkgs = self.legacyPackages.${flake-utils.lib.system.x86_64-darwin};
        };
        homeConfigurations."reeto@poseidon" = makeCfg rec {
          modules = [ ./systems/poseidon.nix ];
          pkgs = self.legacyPackages.${flake-utils.lib.system.aarch64-darwin};
        };
      }
    );
}
