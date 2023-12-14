{ ... }:
{
  # TODO: Add variants support to vim and merge with home.nix
  imports = [
    ./home.nix
    ./vim
  ];

  variants.minimal = false;
}
