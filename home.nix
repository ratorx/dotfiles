{ config, lib, pkgs, ... }:
{
  imports = [
    ./fish
    ./ssh
    ./vim
    ./en.nix
    ./git.nix
  ];

  accounts.email.accounts = {
    personal.address = "me@ree.to";
    personal.primary = true;
    google.address = "reeto@google.com";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "reeto";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
  home.stateVersion = "22.05";

  home.language.base = "en_GB.UTF-8";
  home.packages = [
    pkgs.btop
    pkgs.curlie
    pkgs.darkhttpd
    pkgs.jq
    pkgs.neofetch
    pkgs.dnsutils
    pkgs.ncdu_1
    pkgs.hyperfine
    pkgs.ripgrep
    pkgs.custom.pubip
  ];
  home.sessionVariables = rec {
    LESSHISTFILE = "/dev/null";
    LESS = "--RAW-CONTROL-CHARS --ignore-case --mouse --tabs=2 --quit-if-one-screen";
    SYSTEMD_LESS = LESS;
    # If Go is used, it will default GOPATH to $HOME/go
    # However, the proper place for it is underneath $XDG_DATA_HOME.
    GOPATH = "${config.home.sessionVariables.XDG_DATA_HOME}/go";
  };

  programs.bat = {
    enable = true;
    config.theme = "TwoDark";
  };

  programs.eza.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf.enable = true;
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    shortcut = "space";
    extraConfig = ''
      set-option -g mouse on

      set -ga terminal-overrides ",xterm-256color:Tc"
      set -ga terminal-overrides ",tmux-256color:Tc"

      set -g focus-events on
      set -g set-clipboard on

      unbind -n Escape

      # style
      # pane
      set -g pane-border-style "fg=colour15"
      set -g pane-active-border-style "fg=colour15"
      # messaging
      set -g message-style "fg=default,bg=default"
      set -g automatic-rename on
      # window indicator
      setw -g mode-style "fg=black,bg=blue"
      # status line
      set -g status-justify left
      set -g status-style "fg=default,bg=default"
      setw -g window-status-format "#[fg=colour8] #W "
      setw -g window-status-current-format "#[fg=colour4] •#[fg=colour7] #W "
      set -g status-position bottom
      set -g status-justify centre
      set -g status-left " #{?client_prefix,#[fg=colour5]•••,   }"
      set -g status-right "#{?window_zoomed_flag,#[fg=colour2]•••,#{?pane_synchronized,#[fg=colour4]•••,   }} "
      set -g status-interval 1

      set -g status on
    '';
  };
}
