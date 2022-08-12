{ inputs, ... }:
{
  imports = [
    ../base.nix
    (inputs.autofix-vscode-server + "/modules/vscode-server/home.nix")
  ];

  services.vscode-server.enable = true;
}
