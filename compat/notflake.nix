# Hack for compatibility with non-flake Nix tools and projects
# notflake.nix uses edolstra/flake-compat to get the effective default.nix if
# flakes were not used. The nice thing is that flake-compat itself is managed by
# flake.nix as a non-flake dependency.
(import
  (
    let
      lock = builtins.fromJSON (builtins.readFile ../flake.lock);
    in
    fetchTarball {
      url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
      sha256 = lock.nodes.flake-compat.locked.narHash;
    }
  )
  {
    src = ./..;
  }).defaultNix
