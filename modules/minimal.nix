{ config, lib, pkgs, ... }:
{
  imports = [
    ./fish
    ./en.nix
    ./git.nix
  ];

  # TODO: Add minimality as an option here
  # TODO: Add Google-ness as an option here
  config = lib.mkMerge [
    {
      accounts.email.accounts = {
        personal.address = "me@ree.to";
        personal.primary = true;
        google.address = "reeto@google.com";
      };

      home.username = "reeto";
      home.stateVersion = "22.05";
      home.language.base = "en_GB.UTF-8";

      xdg.enable = true;
      home.sessionVariables = {
        LESSHISTFILE = "/dev/null";
        LESS = "--RAW-CONTROL-CHARS --ignore-case --mouse --tabs=2 --quit-if-one-screen";
        # If Go is used, it will default GOPATH to $HOME/go
        # However, the proper place for it is underneath $XDG_DATA_HOME.
        GOPATH = "${config.home.sessionVariables.XDG_DATA_HOME}/go";
        CARGO_HOME = "${config.home.sessionVariables.XDG_DATA_HOME}/cargo";
      };

      programs.home-manager.enable = true;
    }
    (lib.mkIf pkgs.stdenv.isLinux {
      home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
      home.sessionVariables.SYSTEMD_LESS = config.home.sessionVariables.LESS;
    })
    (lib.mkIf pkgs.stdenv.isDarwin {
      home.homeDirectory = lib.mkDefault "/Users/${config.home.username}";
      home.sessionVariablesExtra = ''
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi
      '';
    })
  ];
}
