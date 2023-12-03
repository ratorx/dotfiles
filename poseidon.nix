{ ... }: {
  imports = [ ./mac.nix ./modules/ssh-agent.nix ];

  services.ssh-agent.enable = true;
}
