{ pkgs, lib, config, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      g = "git";
      # Shortcut for dotfile operations
      d = "git -C ${lib.escapeShellArg config.home.homeDirectory}/.config/home-manager";
      # Setup a new Nix flake with direnv nix-shell
      nixify = "nix flake init -t github:ratorx/base";
      # Refresh credentials for SSH
      refressh = "ssh-add -D && ssh-add -K";
      # ls -> eza
      ls = "eza -xF";
      la = "ls -a";
      lh = "ls -d .*";
      lt = "ls -T --group-directories-first";
      ll = "eza -lF";
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
      gssh = "/usr/local/bin/rw --check_remaining";
    };
    interactiveShellInit = (builtins.readFile ./interactive.fish);
  };

  # WARNING: Attempting to re-create this shim in ZSH is futile, because path_helper (which is called in the profile stage), will re-order the PATH set in env stage. So MacOS devices are better off settting Bash as the user shell and not complicating it even more.
  # Manually link files for two reasons:
  #   * MacOS uses an old version of Bash that errors on HM config
  #   * Keep dependencies minimal
  home.file = {
    # Session shim always; only fish shim if interactive
    ".bashrc".text = ''
      [[ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ]] && source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      if [[ "$-" =~ i && "$(${pkgs.coreutils}/bin/basename "$SHELL")" == "bash" ]]; then
        FISH="${pkgs.fish}/bin/fish"
        exec env SHELL="$FISH" "$FISH"
      fi
    '';
    # Run .bashrc for login shells as well
    ".bash_profile".text = ''
      [[ -f ~/.bashrc ]] && source ~/.bashrc
    '';
  };
}
