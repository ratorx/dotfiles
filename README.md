# Dotfiles v3

[Home Manager](https://github.com/nix-community/home-manager) based user configuration for all my systems.

Dotfiles v1 (using `modman`) is stored in the `v1` branch.
Dotfiles v2 (using [yadm](https://github.com/TheLocehiliosan/yadm)) is stored in the `v2` branch.

This repository should only contain user config. It expects:
* A user with the configured username to exist.
* The system has a functional installation of Nix (which supports flakes) and the user has access to it.
* User shell is `bash` or `fish`.

Currently, the config is mostly focused on terminal and CLI applications (i.e. not a replacement for the `v2` branch, which configured GUI as well).

## Programs
Enumerating all the programs seems pointless and likely to get instantly outdated. Instead, this section will focus on the main choices.

Fish is the default interactive shell. However, since the default user shell is not managed by this config (and has the possibility of locking out the user if something is broken with Nix), a Bash shim into Fish is included.

Neovim is the default terminal editor. It is deliberately not set up as an IDE, since VS Code with Remote SSH Development is better. Instead, the focus is on making the editing experience as nice as possible, with very little language-specific support.

Direnv + nix-direnv is a really nice way to develop isolated projects. Each project independently specifies all of its runtime and build time dependencies. Thus, language and toolchain specific packages don't have to be present in the global configuration.

## Useful Scripts

* `,` (based on [nix-community/comma](https://github.com/nix-community/comma)) - Run any binary packaged in nixpkgs without modifying the user profile. Changed to be flake-specific and use the config version of nixpkgs[^1]. Uses `nix-index` (and `nix-index-database`) and `nix shell`.

## Usage

To apply:

```
nix run github:ratorx/dotfiles
```

Once home-manager is installed, it can also be used with the `--flake` argument. The recommended directory to clone the repository for local changes is `$HOME/.config/nixpkgs`, since home-manager will check that by default.

### More explicit version (from a local clone):

```
nix build .#PROFILE && ./result/activate
```

[^1]: This is faster (does not need to check nixpkgs master state), likely local (config nixpkgs is more likely to already be in the store) and avoids possible version skew between config and binary.
