#!/usr/bin/bash

# File to store the state
state_file=~/.config/.low_power_mode
css_file=~/.config/waybar/style.css

# Check if the state file exists
if [ -e "$state_file" ]; then
    # If the file exists, disable low power mode
    sed -i 's/background-color: @aurora_yellow;/background-color: @frost_light;/g' "$css_file"
    rm "$state_file"
    hyprctl reload
	swww img ~/.config/wallpaper
	notify-send "Low Power Mode Disabled"
	killall waybar && waybar
else
    # If the file doesn't exist, enable low power mode
    sed -i 's/background-color: @frost_light;/background-color: @aurora_yellow;/g' "$css_file"
    touch "$state_file"
    hyprctl keyword decoration:blur:enabled false
    hyprctl keyword decoration:drop_shadow false
    hyprctl keyword animations:enabled false
    hyprctl keyword decoration:active_opacity 2
    hyprctl keyword decoration:inactive_opacity 2
    convert ~/.config/wallpaper[0] ~/.config/low_power
	swww img ~/.config/low_power
	notify-send "Low Power Mode Enabled"
	killall waybar && waybar
fi