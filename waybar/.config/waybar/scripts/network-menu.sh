#!/bin/bash
# Quick wifi picker — mimics GNOME's network popover

# Check if wifi is on
WIFI_STATE=$(nmcli radio wifi)

# Build menu options
TOGGLE="󰖩  Toggle WiFi ($WIFI_STATE)"
SETTINGS="  Network Settings"
RESCAN="  Rescan Networks"

# Scan and list networks (signal, SSID, security)
NETWORKS=$(nmcli --fields IN-USE,SIGNAL,SECURITY,SSID device wifi list \
    | awk 'NR>1 && $NF!="--" {
        inuse = ($1=="*") ? "󰸞 " : "  "
        sig = $2
        sec = ($3=="--") ? "󰌎" : "󰌾"
        ssid = ""
        for (i=4; i<=NF; i++) ssid = ssid (i>4?" ":"") $i
        printf "%s%s  %s%%  %s\n", inuse, sec, sig, ssid
    }' | sort -u)

CHOICE=$(printf "%s\n%s\n%s\n%s" "$TOGGLE" "$RESCAN" "$SETTINGS" "$NETWORKS" \
    | wofi --dmenu --prompt "Network" --width 400 --height 450 \
           --style ~/.config/waybar/scripts/wofi-network.css 2>/dev/null)

[ -z "$CHOICE" ] && exit 0

case "$CHOICE" in
    *"Toggle WiFi"*)
        [ "$WIFI_STATE" = "enabled" ] && nmcli radio wifi off || nmcli radio wifi on
        ;;
    *"Network Settings"*)
        nm-connection-editor &
        ;;
    *"Rescan"*)
        nmcli device wifi rescan
        notify-send "Network" "Rescanning..." -t 2000
        ;;
    *)
        # Extract SSID (everything after the signal %)
        SSID=$(echo "$CHOICE" | sed -E 's/^.{2}.{2}\s+[0-9]+%\s+//')
        # Already connected? Do nothing
        if nmcli -t -f NAME connection show --active | grep -qx "$SSID"; then
            notify-send "Network" "Already connected to $SSID" -t 2000
            exit 0
        fi
        # Try connecting (uses saved creds if available)
        if ! nmcli device wifi connect "$SSID" 2>/dev/null; then
            # Need password — prompt via wofi
            PASS=$(wofi --dmenu --password --prompt "Password for $SSID")
            [ -n "$PASS" ] && nmcli device wifi connect "$SSID" password "$PASS"
        fi
        ;;
esac
