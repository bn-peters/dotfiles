#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch polybar for each monitor
for m in $(polybar --list-monitors | cut -d":" -f1); do
    if [ "$m" = "eDP-1" ]; then
        TRAY_POS=right MONITOR=$m polybar main &
    else
        MONITOR=$m polybar other &
    fi
done
