{ pkgs, ... }: {
  imports = [ ./modules/ssh-agent.nix ];

  home.packages = [
    pkgs.openssh
  ];
  services.ssh-agent.enable = true;
}
