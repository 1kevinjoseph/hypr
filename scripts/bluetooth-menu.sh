#!/bin/bash

# Simple wofi menu for Bluetooth
options="Toggle Power\nConnect Device\nDisconnect Device"

chosen=$(echo -e "$options" | wofi --dmenu --prompt "Bluetooth" --width 300 --height 200)

case $chosen in
    "Toggle Power")
        if bluetoothctl show | grep -q "Powered: yes"; then
            bluetoothctl power off && notify-send "Bluetooth" "Powered Off"
        else
            bluetoothctl power on && notify-send "Bluetooth" "Powered On"
        fi
        ;;
    "Connect Device")
        # List paired devices and connect to selected
        devices=$(bluetoothctl devices | cut -d ' ' -f 3-)
        selection=$(echo "$devices" | wofi --dmenu --prompt "Connect to...")
        mac=$(bluetoothctl devices | grep "$selection" | cut -d ' ' -f 2)
        bluetoothctl connect "$mac" && notify-send "Bluetooth" "Connected to $selection"
        ;;
    "Disconnect Device")
        bluetoothctl disconnect && notify-send "Bluetooth" "Disconnected"
        ;;
esac