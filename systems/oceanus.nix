{ pkgs, lib, config, ... }:
let
  # Needs access to non-Nix dependencies via PATH
  simpleBin = (name: deps: 
    pkgs.writeShellScriptBin name ''
      PATH=${lib.makeBinPath deps}:"$PATH"

      ${builtins.readFile (../bin + "/${name}.sh")}
    '');
in
{
  imports = [../base.nix];

  home.packages = [
    (simpleBin "irctunnel" [ pkgs.autossh pkgs.tmux ])
    (simpleBin "authrefresh" [])
  ];

  home.sessionVariables = {
    NIX_SSL_CERT_FILE = "/etc/ssl/cert.pem";
  };

  home.sessionVariablesExtra = ''
    . "${pkgs.nix}/etc/profile.d/nix.sh"
  '';
  programs.git.userEmail = config.accounts.email.accounts.google.address;
}