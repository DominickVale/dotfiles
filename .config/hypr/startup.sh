#!/bin/bash
export XDG_CURRENT_DESKTOP=Unity

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
~/.config/sway/scripts/import-gsettings &

waybar &
