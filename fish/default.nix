{ pkgs, lib, config, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      g = "git";
      # Shortcut for dotfile operations
      d = "git -C ${lib.escapeShellArg config.home.homeDirectory}/.config/nixpkgs";
      # Setup a new Nix flake with direnv nix-shell
      nixify = "nix flake init -t github:ratorx/base";
      # Refresh credentials for SSH
      refressh = "ssh-add -D && ssh-add -K";
      # ls -> exa
      ls = "exa -xF";
      la = "ls -a";
      lh = "ls -d .*";
      lt = "ls -T --group-directories-first";
      ll = "exa -lF";
      lla = "ll -a";
      # safer fs
      mv = "mv -v";
      rm = "rm -Iv";
      cp = "cp -v";
      df = "df -hl";
      du = "du -h";
      # Network
      pubip = "string trim -c '\"' $(${pkgs.dnsutils}/bin/dig +short txt ch whoami.cloudflare @1.1.1.1)";
      # System
      scu = "systemctl --user";
      hm = "home-manager";
      # Google
      gssh = "/usr/local/bin/rw --cider --check_remaining";
    };
    interactiveShellInit = (builtins.readFile ./interactive.fish);
  };

  # Shim into Fish from Bash or ZSH if interactive and $SHELL is set
  home.file =
    let
      hmSessionShim = "[[ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ]] && . ~/.nix-profile/etc/profile.d/hm-session-vars.sh";
      fishShim = (shell: ''
        if [[ "$(${pkgs.coreutils}/bin/basename "$SHELL")" == "${shell}" ]]; then
          FISH="${pkgs.fish}/bin/fish"
          exec env SHELL="$FISH" "$FISH"
        fi
      '');
    in
    {
      # Session shim always; only fish shim if interactive
      ".bashrc".text = ''
        ${hmSessionShim}
        [[ $- == *i* ]] || return
        ${fishShim "bash"}
      '';
      # Run .bashrc for login shells as well
      ".bash_profile".text = ''
        [[ -f ~/.bashrc ]] && . ~/.bashrc
      '';

      # .zshenv is always run
      ".zshenv".text = hmSessionShim;
      # .zshrc only run when interactive
      ".zshrc".text = fishShim "zsh";
    };
}
