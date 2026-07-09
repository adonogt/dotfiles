#!/bin/bash
# monitor-hotplug.sh
# listens to hyprland socket2 for monitor hotplug events
#
# behavior:
#   hdmi-a-1 connected   → disable eDP-1, move all workspaces to external
#   hdmi-a-1 disconnected → re-enable eDP-1, move workspaces back
INTERNAL="eDP-1"
EXTERNAL="HDMI-A-1"
handle() {
    case "$1" in
        "monitoradded>>$EXTERNAL")
            # sleep 1 lets hyprland stabilize — avoids false positives on reload
            sleep 1
            # verify external is actually present before acting
            if hyprctl monitors all | grep -q "^Monitor $EXTERNAL "; then
                hyprctl eval 'hl.monitor({output="eDP-1", disabled=true}); hl.monitor({output="HDMI-A-1", mode="2560x1440@60", position="0x0", scale=1})'
                hyprctl dispatch moveworkspacetomonitor "1 HDMI-A-1"
                hyprctl dispatch moveworkspacetomonitor "2 HDMI-A-1"
                sleep 0.5
                pkill waybar; nohup waybar > /dev/null 2>&1 &
            fi
            ;;
        "monitorremoved>>$EXTERNAL")
            sleep 0.1
            # same fix here: one eval call instead of two, atomic.
            # also: if eDP-1 and HDMI-A-1 are ever both enabled at once,
            # HDMI-A-1's x position must be >= 1600 (eDP-1's logical width
            # at scale 1.2), not 1280 — see hyprland.lua for the static config
            hyprctl eval 'hl.monitor({output="HDMI-A-1", disabled=true}); hl.monitor({output="eDP-1", disabled=false})'
            hyprctl dispatch moveworkspacetomonitor "1 eDP-1"
            hyprctl dispatch moveworkspacetomonitor "2 eDP-1"
            sleep 0.5
            pkill waybar; nohup waybar > /dev/null 2>&1 &
            ;;
    esac
}
# startup check — external may already be connected when hyprland starts
# both monitor changes go in ONE hyprctl eval call (single lua script, applied
# atomically) instead of two separate calls — avoids a race window where
# HDMI-A-1 gets repositioned to 0x0 before eDP-1 has actually been disabled,
# which is what was causing the overlap warning on boot
if hyprctl monitors all | grep -q "^Monitor $EXTERNAL "; then
    hyprctl eval 'hl.monitor({output="eDP-1", disabled=true}); hl.monitor({output="HDMI-A-1", mode="2560x1440@60", position="0x0", scale=1})'
    hyprctl dispatch moveworkspacetomonitor "1 HDMI-A-1"
    hyprctl dispatch moveworkspacetomonitor "2 HDMI-A-1"
    sleep 0.5
    pkill waybar; nohup waybar > /dev/null 2>&1 &
fi
# -U = unidirectional (read-only from socket2)
socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" \
    | while read -r line; do
        handle "$line"
      done
