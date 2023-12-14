{ pkgs, config, ... }: {
  home.packages = [
    pkgs.custom.authrefresh
    pkgs.custom.itermcopy
  ];

  home.sessionVariables = {
    NIX_SSL_CERT_FILE = "/etc/ssl/cert.pem";
  };

  programs.git.userEmail = config.accounts.email.accounts.google.address;
}
