#!/bin/bash
while true; do 
    BATINFO=`acpi -b | grep -v 'rate information unavailable' | grep 'Battery 0'`
    if [[ `echo $BATINFO | grep Discharging` ]] ; then
        if (( `echo $BATINFO | perl -pe 's/.* (\d+)%.*/\1/'` < 20 )) ; then
            /usr/bin/notify-send -t 30000 -u critical "Battery low"
        fi
    fi
    sleep 30
done
