#!/usr/bin/bash

# Path to a file where the current state will be stored.
STATE_FILE="/tmp/monitor_state"

# Check how many monitors are connected.
MONITOR_COUNT=$(hyprctl monitors | grep -c "Monitor")
MONITOR_NAME=$(hyprctl monitors | grep "Monitor")

# Only proceed if more than one monitor is connected.
if [ "$MONITOR_COUNT" -gt 1 ] || [[ "$MONITOR_NAME" =~ ID\ 1 ]]; then
    # Check the current state and toggle the monitor accordingly.
    if [ -f "$STATE_FILE" ]; then
        # If the state file exists, re-enable the monitor and delete the state file.
        hyprctl keyword monitor eDP-1,highres,0x1080,1
        rm "$STATE_FILE"
    else
        # If the state file does not exist, disable the monitor and create the state file.
        hyprctl keyword monitor eDP-1,disable
        touch "$STATE_FILE"
    fi
else
    echo "Only one monitor is connected. Exiting script."
fi