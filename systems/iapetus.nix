{ config, ... }: {
  home.homeDirectory = "/usr/local/google/home/${config.home.username}";
}
