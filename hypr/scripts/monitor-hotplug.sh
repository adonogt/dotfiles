#!/bin/bash
# monitor-hotplug.sh
# listens to hyprland socket2 for monitor hotplug events
#
# behavior:
#   hdmi-a-1 connected   → disable eDP-1, set external to exact specs
#   hdmi-a-1 disconnected → re-enable eDP-1 with exact specs

INTERNAL="eDP-1"
EXTERNAL="HDMI-A-1"

handle() {
    case "$1" in
        "monitoradded>>$EXTERNAL")
            # sleep 1 lets hyprland stabilize — avoids false positives on reload
            sleep 1
            # verify external is actually present before acting
            if hyprctl monitors all | grep -q "^Monitor $EXTERNAL "; then
                hyprctl eval 'hl.monitor({output="eDP-1", disabled=true})'
                hyprctl eval 'hl.monitor({output="HDMI-A-1", mode="2560x1440@60", position="0x0", scale=1})'
            fi
            ;;
        "monitorremoved>>$EXTERNAL")
            sleep 0.1
            hyprctl eval 'hl.monitor({output="eDP-1", disabled=false})'
            hyprctl eval 'hl.monitor({output="HDMI-A-1", disabled=true})'
            ;;
    esac
}

# startup check — external may already be connected when hyprland starts
if hyprctl monitors all | grep -q "^Monitor $EXTERNAL "; then
    hyprctl eval 'hl.monitor({output="eDP-1", disabled=true})'
    hyprctl eval 'hl.monitor({output="HDMI-A-1", mode="2560x1440@60", position="0x0", scale=1})'
fi

# -U = unidirectional (read-only from socket2)
socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" \
    | while read -r line; do
        handle "$line"
      done
