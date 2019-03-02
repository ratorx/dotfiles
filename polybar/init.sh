#! /bin/bash
set -ex

DOTDIR="$HOME/.dotfiles"
echo "Setup Polybar VPN hook"
sudo -s cp "$DOTDIR/polybar/polybar-vpn" /etc/NetworkManager/dispatcher.d
