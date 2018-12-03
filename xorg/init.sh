#! /bin/bash
echo "Override getty@tty1 with autologin service file"
sudo -s ln -s "$HOME/.dotfiles/xorg/autologin.conf" /etc/systemd/system/getty@tty1.service.d/override.conf
