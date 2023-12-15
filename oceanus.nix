{ pkgs, ... }: {
  home.packages = [
    pkgs.custom.authrefresh
    pkgs.custom.itermcopy
  ];
  home.sessionVariables = {
    NIX_SSL_CERT_FILE = "/etc/ssl/cert.pem";
  };
  variants.minimal = false;
  variants.work = true;
}
