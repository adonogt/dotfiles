#!/usr/bin/env bash

# --- CONFIGURATION ---
theme="$HOME/.config/rofi/powermenu/powermenu.rasi"
uptime=$(uptime -p | sed -e 's/up //g')

# --- ICONS (Simple Arrows) ---
shutdown='→'
reboot='↻'
logout='←'
yes='✓'
no='✗'

# --- FUNCTION: MAIN MENU ---
run_rofi() {
    echo -e "$logout\n$reboot\n$shutdown" | rofi \
        -dmenu \
        -mesg "goodbye.&#x0a;<span size='small' color='#867970'>Uptime: $uptime</span>" \
        -theme ${theme}
}

# --- FUNCTION: CONFIRMATION ---
# Reuse the same theme but change the message
confirm_cmd() {
    echo -e "$no\n$yes" | rofi \
        -dmenu \
        -p "Are you sure?" \
        -mesg "Power off?" \
        -theme ${theme}
}

# --- LOGIC ---
chosen="$(run_rofi)"

case ${chosen} in
    $shutdown)
        # Open confirmation menu before executing
        selected="$(confirm_cmd)"
        if [[ "$selected" == "$yes" ]]; then
            systemctl poweroff
        fi
        ;;
    $reboot)
        systemctl reboot
        ;;
    $logout)
        i3-msg exit
        ;;
esac
