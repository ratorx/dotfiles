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
      (system: {
        legacyPackages = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        # Make a system-specific package for every homeConfiguration
        packages = nixpkgs.lib.attrsets.filterAttrs
          (_: v: v.system == system)
          (builtins.mapAttrs (_: cfg: cfg.activationPackage) self.homeConfigurations);
        apps.default = flake-utils.lib.mkApp {
          drv = self.legacyPackages.${system}.writeShellScriptBin "apply-config" ''
            set -x
            ${home-manager.packages.${system}.home-manager}/bin/home-manager --flake "${./.}" switch
          '';
        };
      }) // {
      homeConfigurations."reeto@zeus" = home-manager.lib.homeManagerConfiguration rec {
        system = flake-utils.lib.system.x86_64-linux;
        configuration = import ./home.nix;
        username = "reeto";
        homeDirectory = "/home/${username}";
        stateVersion = "22.05";
        pkgs = self.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs;
          flakeRoot = builtins.toString ./.;
        };
      };
    };
}
