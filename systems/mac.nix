{ config, pkgs, ... }: {
  home.homeDirectory = "/Users/${config.home.username}";
  home.packages = [
    pkgs.openssh
  ];
  home.sessionVariablesExtra = ''
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
  '';
}
