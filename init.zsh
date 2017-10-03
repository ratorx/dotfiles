#!/usr/bin/zsh
# .zshenv
ln -s "$HOME/.config/shell/.zshenv" "$HOME/.zshenv"

# .gitconfig
ln -s "$HOME/.config/shell/gitconfig" "$HOME/.gitconfig"

# .ssh/
ln -s "$HOME/.config/shell/ssh/config" "$HOME/.ssh/config"
ln -s "$HOME/.config/shell/ssh/keys" "$HOME/.ssh/authorized_keys"
