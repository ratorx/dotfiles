{ pkgs, lib, config, ... }:
{
  imports = [ ../base.nix ];

  home.homeDirectory = "/Users/${config.home.username}";
  home.packages = [
    (pkgs.custom.shellUtil {
      src = ../bin/irctunnel.sh;
      deps = [ pkgs.autossh pkgs.tmux ];
      pure = false;
    })
    (pkgs.custom.shellUtil {
      src = ../bin/authrefresh.sh;
      pure = false;
    })
  ];

  home.sessionVariables = {
    NIX_SSL_CERT_FILE = "/etc/ssl/cert.pem";
  };

  # TODO: Migrate to multi-user installation of to keep things simpler
  home.sessionVariablesExtra = ''
    . "${pkgs.nix}/etc/profile.d/nix.sh"
  '';
  programs.git.userEmail = config.accounts.email.accounts.google.address;
}
