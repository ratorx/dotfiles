{ nixpkgs, ... }:
final: prev:
let
  pkgs = final;
  lib = final.lib;
  makeShellBin = (
    {
      src,
      # Dependencies to provide via makeBinPath
      deps ? [ ],
      # Pure mode replaces PATH; otherwise it is only prepended
      pure ? true,
      extraEnv ? "",
    }:
    pkgs.writeShellScriptBin (lib.strings.removeSuffix ".sh" (builtins.baseNameOf src)) ''
      PATH=${lib.makeBinPath deps}${if pure then "" else ":\"$PATH\""}
      ${extraEnv}

      ${builtins.readFile src}
    ''
  );
in
{
  custom = {
    builder = {
      nvimbench = (
        nvim:
        makeShellBin {
          src = ./bin/nvimbench.sh;
          deps = [
            nvim
            pkgs.coreutils
            pkgs.less
          ];
        }
      );
    };
    fzf-git-log = makeShellBin {
      src = ./bin/fzf-git-log.sh;
      deps = [
        pkgs.coreutils
        pkgs.gnugrep
        pkgs.findutils
        pkgs.gawk
        pkgs.fzf
        pkgs.git
        pkgs.less
      ];
    };
    itermcopy = makeShellBin {
      src = ./bin/itermcopy.sh;
      deps = [
        pkgs.coreutils
        pkgs.gnugrep
      ];
    };
    irctunnel = makeShellBin {
      src = ./bin/irctunnel.sh;
      deps = [
        pkgs.autossh
        pkgs.tmux
      ];
      pure = false;
    };
    maybe-gcert = makeShellBin {
      src = ./bin/maybe-gcert.sh;
      deps = [ pkgs.findutils ];
      pure = false;
    };
    n = makeShellBin {
      src = ./bin/n.sh;
      deps = [
        pkgs.fzf
        pkgs.git
        pkgs.nix
        pkgs.nix-index-with-db
      ];
      extraEnv = "FLAKE=${nixpkgs}";
    };
    nman = makeShellBin {
      src = ./bin/nman.sh;
      deps = [
        pkgs.fzf
        pkgs.nix
        pkgs.nix-index-with-db
      ];
      extraEnv = "FLAKE=${nixpkgs}";
    };
    pkgfile = makeShellBin {
      src = ./bin/pkgfile.sh;
      deps = [
        pkgs.nix-index-with-db
        pkgs.gnused
      ];
      pure = false;
    };
    pkgbin = pkgs.writeShellScriptBin "pkgbin" ''
      exec ${pkgs.custom.pkgfile}/bin/pkgfile --type x "$@"
    '';
    pubip = makeShellBin {
      src = ./bin/pubip.sh;
      deps = [
        pkgs.coreutils
        pkgs.dnsutils
      ];
    };
  };

  nix-index = builtins.throw "Use nix-index-with-db instead";
}
