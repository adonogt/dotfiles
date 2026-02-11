#!/bin/bash
STATE="/tmp/night_mode"

if [ -f "$STATE" ]; then
    redshift -x
    rm "$STATE"
else
    redshift -O 3000 -b 0.9
    touch "$STATE"
fi
