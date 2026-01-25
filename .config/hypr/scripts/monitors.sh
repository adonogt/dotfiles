#!/bin/bash

# define internal and external monitor names
internal="eDP-1"
external="HDMI-A-1"

# check if external monitor is connected
if hyprctl monitors | grep -q "$external"; then
    # external monitor is connected → enable external and disable internal
    hyprctl keyword monitor "$external,preferred,auto,1"
    hyprctl keyword monitor "$internal,disable"

    # move all workspaces to the external monitor
    for ws in $(seq 1 10); do
        hyprctl dispatch moveworkspacetomonitor "$ws $external" >/dev/null 2>&1
    done

    # restart waybar on external monitor
    killall waybar 2>/dev/null
    WAYBAR_MONITOR=$external waybar &

else
    # external monitor is not connected → enable internal monitor
    hyprctl keyword monitor "$internal,preferred,auto,1"

    # move all workspaces back to the internal monitor
    for ws in $(seq 1 10); do
        hyprctl dispatch moveworkspacetomonitor "$ws $internal" >/dev/null 2>&1
    done

    # restart waybar on internal monitor
    killall waybar 2>/dev/null
    WAYBAR_MONITOR=$internal waybar &
fi

