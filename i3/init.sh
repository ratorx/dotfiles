#! /bin/bash
MODULE_DIR="$HOME/.dotfiles/i3"
set -ex

function service_install() {
    sudo -s ln -s "$MODULE_DIR/services/$1.service" /etc/systemd/system
    sudo systemctl enable "$1.service"
}

function is_laptop() {
    for filename in /sys/class/power_supply/*/type; do
        if [ "$(cat "$filename")" = "Battery" ]; then
            return 0
        fi
    done

    return 1
}

service_install i3lock

if is_laptop; then
    service_install backlight
    sudo -s ln -s "$MODULE_DIR/udev/90-powersave.rules" /etc/udev/rules.d
    sudo -s ln -s "$MODULE_DIR/scripts/backlight" /usr/bin
fi
