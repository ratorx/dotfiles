#! /bin/bash
echo "Override getty@tty1 with autologin service file"
# Symlink does not work, need to copy
sudo -s cp "$HOME/.dotfiles/xorg/autologin.conf" /etc/systemd/system/getty@tty1.service.d/override.conf
