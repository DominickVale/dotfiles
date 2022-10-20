#!/bin/bash
# Script that accepts a brightness value $1 and displays a notification bar with value progress in notify-send
# Requires: notify-send, brightnessctl

# Set brightness value via brightnessctl
brightnessctl s $1

# Get current brightness value via brightnessctl
current=$(brightnessctl g)

# Get max brightness value via brightnessctl
max=$(brightnessctl m)

# Calculate percentage of current brightness value
percent=$(echo "scale=2; $current / $max * 100" | bc)

# Display notification bar with value progress
notify-send -t 1000 -u low -h string:x-canonical-private-synchronous:notify-bar -h int:value:$percent -h int:maximum:100 "Brightness" " "


