#!/bin/bash

# Check if playerctl is running and a player is active
if ! playerctl status &>/dev/null; then
    echo ""
    exit 0
fi

STATUS=$(playerctl status 2>/dev/null)

if [[ "$STATUS" == "Playing" ]]; then
    ICON="󰎈"  # Nerd Font playing icon
elif [[ "$STATUS" == "Paused" ]]; then
    ICON="󰏤"  # Nerd Font paused icon
else
    echo ""
    exit 0
fi

TITLE=$(playerctl metadata title 2>/dev/null)
ARTIST=$(playerctl metadata artist 2>/dev/null)

# Truncate long titles/artists so it fits on screen
MAX=45
SONG="$TITLE - $ARTIST"
if [[ ${#SONG} -gt $MAX ]]; then
    SONG="${SONG:0:$MAX}…"
fi

echo "$ICON  $SONG"