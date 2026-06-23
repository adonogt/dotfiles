#!/bin/bash
# start-greeter.sh
# waits for hyprland to initialize monitors, then conditionally
# disables the internal screen if the external is connected

sleep 0.3

if hyprctl monitors all | grep -q "^Monitor HDMI-A-1 "; then
    hyprctl eval 'hl.monitor({output="eDP-1", disabled=true})'
    sleep 0.1
fi

regreet --style /etc/greetd/regreet.css
hyprctl dispatch 'hl.dsp.exit()'
