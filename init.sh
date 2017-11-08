#!/usr/bin/bash

DOTFILES="$HOME/.dotfiles"

# zsh
ln -s "$DOTFILES/zshenv" "$HOME/.zshenv"
ln -s "$DOTFILES/zshrc" "$HOME/.zshrc"

# antibody
ln -s "$DOTFILES/antibody" "$HOME/.antibody"

# git config
ln -s "$DOTFILES/gitconfig" "$HOME/.gitconfig"

# SSH config
[[ $UID -ne 0 ]] && ln -s "$DOTFILES/ssh/config" "$HOME/.ssh/config"
[[ $UID -ne 0 ]] && ln -s "$DOTFILES/ssh/keys" "$HOME/.ssh/authorized_keys"

# tmux
ln -s "$DOTFILES/tmux.conf" "$HOME/.tmux.conf"
ln -s "$DOTFILES/applications/tmux.desktop" "$HOME/.local/share/applications/tmux.desktop"

# zshmarks
ln -s "$DOTFILES/bookmarks" "$HOME/.bookmarks"

# termite - Don't copy by default to allow for different fonts
# ln -s "$DOTFILES/termite" "$HOME/.config/termite"

# npmrc - Move .npm folder to cache
ln -s "$DOTFILES/npmrc" "$HOME/.npmrc"

# neovim config
ln -s "$DOTFILES/nvim" "$HOME/.config/nvim"
