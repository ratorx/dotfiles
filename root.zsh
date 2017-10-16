#! /usr/bin/zsh
# Set up root zsh session
# Run as regular user

temp=$HOME
sudo -s ln -s $temp/.dotfiles /root/.dotfiles
sudo -s source /root/.dotfiles/init.sh

# Micro setup
sudo -s mkdir -p /root/.config
sudo -s mkdir -p /root/.config/micro
sudo -s ln -s $temp/.config/micro /root/.config