#! /bin/bash

# Terminate already running bar instances
killall -q polybar

# Set device
POLYBAR_DIR="$XDG_CONFIG_HOME/polybar"
export POLYBAR_SCRIPTS="$POLYBAR_DIR/scripts"
export POLYBAR_MODULES="$POLYBAR_DIR/modules"
export DEVICE="$("$POLYBAR_SCRIPTS/device")"
[ "$(hostname)" = "zeus" ] && export WIRED_DISCONNECTED_ICON=""

# Launch polybar on all monitors
MONITORS=${MONITORS:-$(xrandr | awk '/ connected/ { print $1 }')}
declare -A monitors
for i in $MONITORS; do 
	monitors[$i]="MONITOR='$i' polybar top &" 
done

primary="$(xrandr | awk '/connected primary/ {print $1}')"

# wait after all setup has been completed; minimises script execution time
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 0.1; done

# Start on polybar on primary monitor first
eval "TRAY_POSITION=right TRAY_MARGIN=2 ${monitors[$primary]}"

# Start on other monitors
for i in "${!monitors[@]}"; do
	if [ "$i" = "$primary" ]; then
		continue
	fi
	eval "${monitors[$i]}"
done
