{ inputs, flakeRoot, config, lib, pkgs, ... }:

let
  simpleBin = (name: deps: 
    pkgs.writeShellScriptBin name ''
      PATH=${lib.makeBinPath deps}

      ${builtins.readFile (./bin + "/${name}.sh")}
    '');
in
{
  imports = [
    (inputs.autofix-vscode-server + "/modules/vscode-server/home.nix")
    ./fish
    ./ssh
    ./vim
    ./git.nix
    ./nix-index-database.nix
  ];

  targets.genericLinux.enable = true;

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
    (simpleBin "," [ pkgs.fzf pkgs.coreutils pkgs.gawk pkgs.gnugrep pkgs.nix pkgs.nix-index ])
    (simpleBin "pkglocate" [ pkgs.nix-index pkgs.gnused ])
    (simpleBin "nixify" [ pkgs.coreutils pkgs.direnv ])
  ];
  home.sessionVariables = rec {
    LESSHISTFILE = "/dev/null";
    LESS =
      "--quit-if-one-screen --RAW-CONTROL-CHARS --ignore-case --mouse --tabs=2";
    SYSTEMD_LESS = LESS;
    HOME_MANAGER_FLAKE_ROOT = flakeRoot;
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

  services.vscode-server.enable = true;
}
