#! /bin/bash
set -ex
sudo -s ln -s "$HOME/.dotfiles/i3/i3lock.service" /etc/systemd/system
sudo systemctl enable i3lock.service
