{ lib, pkgs, ... }:
# NOTE: Be careful about using variables in this file because the shell
# needs to be restarted to use it.
{
  programs.fish = {
    enable = true;
    shellAliases = {
      g = "git";
      # Shortcut for dotfile operations
      d = "git -C \"$XDG_CONFIG_HOME/home-manager\"";
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
      # System
      scu = "systemctl --user";
      hm = "home-manager";
      # Google
      gssh = "/usr/local/bin/rw --check_remaining";
    };
    interactiveShellInit = lib.mkMerge [
      (builtins.readFile ./interactive.fish)
      (lib.mkIf pkgs.stdenv.isDarwin ''
        set -l iterm "/Applications/iTerm.app/Contents/Resources/iterm2_shell_integration.fish"
        if test -f $iterm
          source $iterm
        end
      '')
    ];
  };

  # WARNING: Attempting to re-create this shim in ZSH is futile, because path_helper (which is called in the profile stage), will re-order the PATH set in env stage. So MacOS devices are better off settting Bash as the user shell and not complicating it even more.
  # Manually link files for two reasons:
  #   * MacOS uses an old version of Bash that errors on HM config
  #   * Keep dependencies minimal
  home.file = {
    ".bashrc".source = ./shim.sh;
    # Run .bashrc for login shells as well
    ".bash_profile".text = ''
      [[ -f ~/.bashrc ]] && source ~/.bashrc
    '';
  };
}
