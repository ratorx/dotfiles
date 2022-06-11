{ inputs, flakeRoot, config, lib, pkgs, ... }:
{
  imports = [
    ./fish
    ./ssh
    ./vim
    ./git.nix
    ./nix-index-database.nix
  ];

  accounts.email.accounts = {
    personal.address = "git@ree.to";
    personal.primary = true;
    google.address = "reeto@google.com";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.enable = true;
  services.nix-index-database.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.language.base = "en_GB.UTF-8";
  home.packages = [
    pkgs.hyperfine
    pkgs.ripgrep
    # VS Code
    pkgs.rnix-lsp
    pkgs.shfmt
    pkgs.shellcheck
    pkgs.vim-vint
    # Custom utilities
    (pkgs.custom.shellUtil {
      src = ./bin/n.sh;
      deps = [ pkgs.fzf pkgs.nix pkgs.nix-index ];
      extraEnv = "FLAKE=${flakeRoot}";
    })
    (pkgs.custom.shellUtil {
      src = ./bin/nman.sh;
      deps = [ pkgs.fzf pkgs.nix pkgs.nix-index ];
      extraEnv = "FLAKE=${flakeRoot}";
    })
    (pkgs.custom.shellUtil {
      src = ./bin/pkglocate.sh;
      deps = [ pkgs.nix-index pkgs.gnused ];
      impure = true;
    })
    (pkgs.custom.shellUtil {
      src = ./bin/nixify.sh;
      deps = [ pkgs.coreutils pkgs.direnv ];
      impure = true;
    })
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
  home.sessionVariables = rec {
    LESSHISTFILE = "/dev/null";
    LESS =
      "--quit-if-one-screen --RAW-CONTROL-CHARS --ignore-case --mouse --tabs=2";
    SYSTEMD_LESS = LESS;
  };

  programs.bat = {
    enable = true;
    config.theme = "TwoDark";
  };

  programs.exa.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf.enable = true;
  programs.tmux.enable = true;
  programs.nix-index.enable = true;
  programs.nnn = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "nnn";
      paths = [ pkgs.nnn ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild =
        let
          # Filter out --quit-if-one-screen from LESS
          # Causes help page to not load when the terminal is big
          nnnLess = builtins.toString (
            builtins.filter
              (s: s != "--quit-if-one-screen")
              (lib.strings.splitString " " config.home.sessionVariables.LESS)
          );
        in
        ''
          wrapProgram $out/bin/nnn --set LESS ${lib.strings.escapeShellArg nnnLess}
        '';
    };
  };
}
