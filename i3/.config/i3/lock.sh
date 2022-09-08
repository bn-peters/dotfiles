#!/usr/bin/env bash

cd /home/silvus/.config/i3/

# take screenshot
import -window root scr.png
# blur screenshot
convert -scale 10% -blur 0x2 -resize 1000% scr.png scr.png

i3lock -i scr.png

if [ "$1" == "-s" ]; then
    systemctl suspend
fi

rm scr.png
