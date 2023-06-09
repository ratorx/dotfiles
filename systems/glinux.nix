{ config, pkgs, ... }: {
  home.homeDirectory = "/usr/local/google/home/${config.home.username}";
  home.packages = [
    (pkgs.custom.shellUtil {
      src = ../bin/itermcopy.sh;
      deps = [ pkgs.coreutils pkgs.gnugrep ];
    })
  ];
  # TODO: Add support to neovim clipboard
  programs.fish.interactiveShellInit = ''
    source_google_fish_package buildfix citc_prompt hi pastebin
  '';
}
