#!/usr/bin/bash
# zsh
ln -s "$HOME/.dotfiles/zshenv" "$HOME/.zshenv"
ln -s "$HOME/.dotfiles/zshrc" "$HOME/.zshrc"

# antibody
ln -s "$HOME/.dotfiles/antibody" "$HOME/.antibody"

# git config
ln -s "$HOME/.dotfiles/gitconfig" "$HOME/.gitconfig"

# SSH config
[[ $UID -ne 0 ]] && ln -s "$HOME/.dotfiles/ssh/config" "$HOME/.ssh/config"
[[ $UID -ne 0 ]] && ln -s "$HOME/.dotfiles/ssh/keys" "$HOME/.ssh/authorized_keys"

# tmux
ln -s "$HOME/.dotfiles/tmux.conf" "$HOME/.tmux.conf"

# termite
ln -s "$HOME/.dotfiles/termite" "$HOME/.config/termite"

# npmrc - Move .npm folder to cache
ln -s "$HOME/.dotfiles/npmrc" "$HOME/.npmrc"
