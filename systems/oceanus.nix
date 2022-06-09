{ pkgs, lib, config, ... }:
{
  imports = [../base.nix];

  home.packages = [
    (pkgs.custom.impureShellScriptBin ../bin/irctunnel.sh [ pkgs.autossh pkgs.tmux ])
    (pkgs.custom.impureShellScriptBin ../bin/authrefresh.sh [])
  ];

  home.sessionVariables = {
    NIX_SSL_CERT_FILE = "/etc/ssl/cert.pem";
  };

  home.sessionVariablesExtra = ''
    . "${pkgs.nix}/etc/profile.d/nix.sh"
  '';
  programs.git.userEmail = config.accounts.email.accounts.google.address;
}