{ config, lib, ... }:
{
  imports = [
    ./fish
    ./en.nix
    ./git.nix
  ];

  accounts.email.accounts = {
    personal.address = "me@ree.to";
    personal.primary = true;
    google.address = "reeto@google.com";
  };

  home.username = "reeto";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
  home.stateVersion = "22.05";
  home.language.base = "en_GB.UTF-8";

  xdg.enable = true;
  home.sessionVariables = {
    LESSHISTFILE = "/dev/null";
    LESS = "--RAW-CONTROL-CHARS --ignore-case --mouse --tabs=2 --quit-if-one-screen";
    SYSTEMD_LESS = config.home.sessionVariables.LESS;
    # If Go is used, it will default GOPATH to $HOME/go
    # However, the proper place for it is underneath $XDG_DATA_HOME.
    GOPATH = "${config.home.sessionVariables.XDG_DATA_HOME}/go";
    CARGO_HOME = "${config.home.sessionVariables.XDG_DATA_HOME}/cargo";
  };

  programs.home-manager.enable = true;
}
