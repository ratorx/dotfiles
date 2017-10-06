#!/usr/bin/bash
# .zshenv
ln -s "$HOME/.dotfiles/zshenv" "$HOME/.zshenv"

# .zshrc
ln -s "$HOME/.dotfiles/zshrc" "$HOME/.zshrc"

# .antibody
ln -s "$HOME/.dotfiles/antibody" "$HOME/.antibody"

# .gitconfig
ln -s "$HOME/.dotfiles/gitconfig" "$HOME/.gitconfig"

# .ssh/
ln -s "$HOME/.dotfiles/ssh/config" "$HOME/.ssh/config"
ln -s "$HOME/.dotfiles/ssh/keys" "$HOME/.ssh/authorized_keys"
