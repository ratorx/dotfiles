{ config, pkgs, ... }: {
  home.homeDirectory = "/usr/local/google/home/${config.home.username}";
  home.packages = [
    (pkgs.custom.shellUtil {
      src = ../bin/itermcopy.sh;
      deps = [ pkgs.coreutils pkgs.gnugrep ];
    })
  ];
  # TODO: Add support to neovim clipboard
}
