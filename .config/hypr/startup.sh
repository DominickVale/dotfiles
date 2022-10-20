#!/bin/bash
export XDG_CURRENT_DESKTOP=Unity
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
~/.config/sway/scripts/import-gsettings &
# Desktop notifications
mako &

# Network Applet
nm-applet --indicator &

# Welcome App
dex -a -s /etc/xdg/autostart/:~/.config/autostart/   &

# General apps
copyq &
blueman-applet &
gammastep &
swww init &&
swww img Pictures/wallpapers/windows-2k.jpeg &

# Waybar
waybar -c ~/.config/waybar/config.hypr &
