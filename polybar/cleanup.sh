#! /bin/bash
set -ex

echo "Remove Polybar VPN hook"
if [ -f "/etc/NetworkManager/dispatcher.d/polybar-vpn" ]; then
    sudo -s rm /etc/NetworkManager/dispatcher.d/polybar-vpn
fi
