{ pkgs, config, ... }: {
  imports = [ ./mac.nix ];

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

  programs.git.userEmail = config.accounts.email.accounts.google.address;
}
