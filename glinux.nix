{ config, pkgs, ... }:
{
  home.homeDirectory = "/usr/local/google/home/${config.home.username}";
  home.packages = [ pkgs.custom.itermcopy ];
  # TODO: Add support to neovim clipboard
  programs.fish.interactiveShellInit = ''
    source_google_fish_package autogcert buildfix citc_prompt hi pastebin
  '';
  variants.minimal = false;
  variants.work = true;
}
