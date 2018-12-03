#! /bin/bash
set -ex
sudo systemctl disable i3lock.service
sudo rm /etc/systemd/system/i3lock.service

