#!/bin/bash
# monitor-hotplug.sh
# hyprland 0.55+: uses hyprctl eval with lua syntax
# hyprctl keyword is not supported with the lua config parser

INTERNAL="eDP-1"
EXTERNAL="HDMI-A-1"

handle() {
    case "$1" in
        "monitoradded>>$EXTERNAL")
            sleep 0.1
            hyprctl eval 'hl.monitor({ output = "eDP-1", disabled = true })'
            hyprctl eval 'hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@60", position = "auto", scale = 1 })'
            ;;
        "monitorremoved>>$EXTERNAL")
            sleep 0.1
            hyprctl eval 'hl.monitor({ output = "eDP-1", disabled = false })'
            ;;
    esac
}

# startup check — external may already be connected when hyprland starts
if hyprctl monitors all | grep -q "^Monitor $EXTERNAL"; then
    hyprctl eval 'hl.monitor({ output = "eDP-1", disabled = true })'
    hyprctl eval 'hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@60", position = "auto", scale = 1 })'
fi

socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" \
    | while read -r line; do
        handle "$line"
      done
