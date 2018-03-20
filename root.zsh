#! /usr/bin/zsh
# Set up root zsh session
# Run as regular user

sudo -s ln -sT $HOME/.dotfiles /root/.dotfiles
sudo /root/.dotfiles/modman install zsh
