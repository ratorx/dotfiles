{ config, lib, pkgs, ... }:
{
  imports = [
    ./fish
    ./vim
    ./en.nix
    ./git.nix
    ./ssh.nix
  ];

  options.variants.minimal = lib.mkOption {
    description = "Whether to use the minimal profile";
    type = lib.types.bool;
  };

  options.variants.work = lib.mkOption {
    description = "Whether to use the work profile";
    type = lib.types.bool;
  };

  config = lib.mkMerge [
    {
      accounts.email.accounts = {
        personal.address = "me@ree.to";
        personal.primary = !config.variants.work;
        work.address = "reeto@google.com";
        work.primary = config.variants.work;
      };

      home.username = "reeto";
      home.stateVersion = "22.05";
      home.language.base = "en_GB.UTF-8";

      xdg.enable = true;
      home.sessionVariables = {
        LESSHISTFILE = "/dev/null";
        LESS = "--RAW-CONTROL-CHARS --ignore-case --mouse --tabs=2";
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
    (lib.mkIf (!config.variants.minimal) {
      home.sessionVariables = {
        # If Go is used, it will default GOPATH to $HOME/go
        # However, the proper place for it is underneath $XDG_DATA_HOME.
        GOPATH = "${config.home.sessionVariables.XDG_DATA_HOME}/go";
        CARGO_HOME = "${config.home.sessionVariables.XDG_DATA_HOME}/cargo";
      };

      home.packages = [
        pkgs.curlie
        pkgs.jq
        pkgs.dnsutils
        pkgs.hyperfine
        pkgs.ripgrep
        pkgs.custom.pubip
      ];

      # TODO: Look into using neovim as man pager
      programs.bat = {
        enable = true;
        config.theme = "TwoDark";
      };
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      programs.eza.enable = true;
      programs.fzf.enable = true;
      # TODO: Consider integrating with service runner
      # for persisting jobs across logout
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
    })
  ];
}
