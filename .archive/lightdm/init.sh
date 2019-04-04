#! /bin/bash

sudo mv /etc/lightdm/lightdm.conf /etc/lightdm.conf.backup
sudo mv /etc/lightdm/lightdm-mini-greeter.conf /etc/lightdm-mini-greeter.conf.backup
sudo rm -f /etc/lightdm/display

sudo -s ln -s "$HOME/.dotfiles/misc/lightdm/lightdm.conf" /etc/lightdm/lightdm.conf
sudo -s ln -s "$HOME/.dotfiles/misc/lightdm/lightdm-mini-greeter.conf" /etc/lightdm/lightdm-mini-greeter.conf
sudo -s ln -s "$HOME/.dotfiles/misc/lightdm/display" /etc/lightdm/display
echo "Installed lightdm"
echo "Run root.zsh to get colour changing login screen"
echo "Make sure lightdm and lightdm-mini-greeter are installed"
