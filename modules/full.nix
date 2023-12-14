{ ... }:
{
  # TODO: Add variants support to vim and ssh and merge with home.nix
  imports = [
    ./home.nix
    ./ssh
    ./vim
  ];

  variants.minimal = false;
}
