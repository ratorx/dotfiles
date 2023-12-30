{ config, lib, pkgs, ... }:
# NOTE: Be careful about using variables in this file because the shell
# needs to be restarted to use it.
{
  programs.fish = {
    enable = true;
    shellAliases = lib.mkMerge [
      {
        cp = "cp -v";
        df = "df -hl";
        du = "du -h";
        hm = "home-manager";
        la = "ls -a";
        lh = "ls -d .*";
        ll = "ls -lF";
        lla = "ll -a";
        mv = "mv -v";
        rm = "rm -Iv";
        which = "type";
      }
      (lib.mkIf config.programs.eza.enable {
        ls = "eza -xF";
        lt = "ls -T --group-directories-first";
      })
      (lib.mkIf config.programs.git.enable {
        g = "git";
        d = "git -C \"$XDG_CONFIG_HOME/home-manager\"";
        dev = "$EDITOR (git ls-files --cached --others --exclude-standard)";
        nixify = "nix flake init -t github:ratorx/base";
      })
      (lib.mkIf pkgs.stdenv.isLinux {
        scu = "systemctl --user";
      })
      (lib.mkIf config.variants.work {
        gssh = "/usr/local/bin/rw --check_remaining";
      })
      (lib.mkIf (!config.variants.work) {
        refressh = "ssh-add -D && ssh-add -K";
      })
    ];
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
