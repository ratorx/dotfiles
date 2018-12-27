#! /bin/bash
set -ex

function service_uninstall() {
    sudo systemctl disable "$1.service"
}

function is_laptop() {
    for filename in /sys/class/power_supply/*/type; do
        if [ "$(cat "$filename")" = "Battery" ]; then
            return 0
        fi
    done

    return 1
}


service_uninstall i3lock

if is_laptop; then
    service_uninstall backlight
    sudo rm /etc/udev/rules.d/backlight.rules
fi
