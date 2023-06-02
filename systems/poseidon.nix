{ ... }: {
  imports = [ ./mac.nix ../ssh-agent.nix ];

  services.ssh-agent.enable = true;
}
