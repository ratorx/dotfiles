{ pkgs, lib, config, ... }:
{
  imports = [ ../base.nix ];

  home.homeDirectory = "/Users/${config.home.username}";

  home.sessionVariablesExtra = ''
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
  '';
}
