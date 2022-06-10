{ pkgs, lib, config, ... }:
{
  imports = [ ../base.nix ];

  home.packages = [
    (pkgs.custom.shellUtil {
      src = ../bin/irctunnel.sh;
      deps = [ pkgs.autossh pkgs.tmux ];
      impure = true;
    })
    (pkgs.custom.shellUtil {
      src = ../bin/authrefresh.sh;
      impure = true;
    })
  ];

  home.sessionVariables = {
    NIX_SSL_CERT_FILE = "/etc/ssl/cert.pem";
  };

  home.sessionVariablesExtra = ''
    . "${pkgs.nix}/etc/profile.d/nix.sh"
  '';
  programs.git.userEmail = config.accounts.email.accounts.google.address;
}
