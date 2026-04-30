#!/bin/bash

# Get a list of available wifi networks
wifi_list=$(nmcli --terse --fields "SSID" device wifi list | sed '/^--/d' | sort -u)

# Use wofi to let the user select a network
chosen_network=$(echo "$wifi_list" | wofi --dmenu --prompt "Select WiFi" --width 400 --height 350)

# Exit if no network was chosen
if [ -z "$chosen_network" ]; then
    exit 0
fi

# Get the connection status of the chosen network
connection_exists=$(nmcli connection show | grep "$chosen_network")

if [ -n "$connection_exists" ]; then
    # If connection exists, try to connect
    if nmcli device wifi connect "$chosen_network"; then
        notify-send "WiFi" "Connected to $chosen_network"
    else
        notify-send "WiFi" "Failed to connect to $chosen_network"
    fi
else
    # If connection doesn't exist, ask for password
    password=$(wofi --dmenu --prompt "Password for $chosen_network" --password --width 400 --height 100)
    
    if [ -z "$password" ]; then
        exit 0
    fi

    if nmcli device wifi connect "$chosen_network" password "$password"; then
        notify-send "WiFi" "Connected to $chosen_network"
    else
        notify-send "WiFi" "Connection failed. Check password."
    fi
fi