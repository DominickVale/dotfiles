#!/bin/bash
# Script that accepts a volume value $1 and displays a notification bar with value progress in notify-send
# Requires: notify-send, pamixer

pamixer $1 $2

percent=$(pamixer --get-volume)
# Display notification bar with value progress
notify-send -t 1000 -u low -h string:x-canonical-private-synchronous:notify-bar -h int:value:$percent -h int:maximum:100 "Volume" " "
