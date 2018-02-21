#! /usr/bin/zsh
# Set up root zsh session
# Run as regular user

sudo -s ln -s $HOME/.dotfiles /root/.dotfiles
sudo -s source /root/.dotfiles/init.sh
