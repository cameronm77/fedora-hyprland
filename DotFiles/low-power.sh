#!/usr/bin/bash

# File to store the state
state_file=~/.config/.low_power_mode
css_file=~/.config/waybar/style.css

# Check if the state file exists
if [ -e "$state_file" ]; then
    # If the file exists, disable low power mode
    sed -i 's/background-color: @aurora_yellow;/background-color: @frost_light;/g' "$css_file"
    rm "$state_file"
    hyprctl keyword decoration:blur:enabled true
    hyprctl keyword decoration:drop_shadow true
	swww img ~/Pictures/Wallpapers/wallpaper.gif
	notify-send "Low Power Mode Disabled"
	killall waybar && waybar
else
    # If the file doesn't exist, enable low power mode
    sed -i 's/background-color: @frost_light;/background-color: @aurora_yellow;/g' "$css_file"
    touch "$state_file"
    hyprctl keyword decoration:blur:enabled false
    hyprctl keyword decoration:drop_shadow false
	swww img ~/Pictures/Wallpapers/nord.jpeg
	notify-send "Low Power Mode Enabled"
	killall waybar && waybar
fi
