#! /bin/bash
echo "Override getty@tty1 with autologin service file"
# Symlink does not work, need to copy
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo -s cp "$HOME/.dotfiles/xorg/autologin.conf" /etc/systemd/system/getty@tty1.service.d/override.conf
