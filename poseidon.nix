{ pkgs, ... }: {
  imports = [ ./modules/ssh-agent.nix ];

  programs.ssh.package = pkgs.openssh;
  services.ssh-agent.enable = true;
  variants.minimal = false;
  variants.work = false;
}
