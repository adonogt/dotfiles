#!/bin/sh

DEVICE=$(upower -e | grep -E 'headset|headphone' | head -n 1)

if [ -z "$DEVICE" ]; then
    echo "‹›"
else
    PERCENTAGE=$(upower -i "$DEVICE" | grep percentage | awk '{print $2}' | tr -d '%')
    
    if [ ! -z "$PERCENTAGE" ]; then
        echo "$PERCENTAGE ∙"
    else
        echo ""
    fi
fi
