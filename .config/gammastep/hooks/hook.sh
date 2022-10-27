#!/bin/env bash
GTK_THEME='Colloid-Compact'
GTK_THEME_NIGHT='Colloid-Dark-Compact'

echo `date` "$1 $2 $3" >> /tmp/gammastep.txt
case $1 in
    period-changed)

        case $3 in
          transition|daytime|none)
            notify-send "Changing to day"
            gsettings set org.gnome.desktop.interface gtk-theme $GTK_THEME
            sed --follow-symlinks -i "s/^gtk-theme-name=.*/gtk-theme-name=$GTK_THEME/g"         $HOME/.config/gtk-3.0/settings.ini
            sed --follow-symlinks -i "s/^gtk-theme-name=.*/gtk-theme-name=\"$GTK_THEME\"/g"     $HOME/.gtkrc-2.0
            sed --follow-symlinks -i '/# DynamicBackground/{n;s/.*/background-color=#000000DD/}' $HOME/.config/mako/config
            sed --follow-symlinks -i '/# DynamicForeground/{n;s/.*/text-color=#ffffff/}' $HOME/.config/mako/config
            sed --follow-symlinks -i 's/background = \"dark\"/background = \"light\"/g' $HOME/.config/nvim/lua/user/init.lua
            sed --follow-symlinks -i -E "s/(url.*)dark/\1light/g"    $HOME/.config/waybar/style.css 
            $HOME/.local/src/gogh/themes/papercolor-light.sh
            hyprctl --batch "keyword general:border_size 3 ; keyword decoration:inactive_opacity 0.75 ; keyword decoration:active_opacity 0.95 ; keyword general:col.active_border rgba(daa520ff)" 
            ;;
          night)
            notify-send "Changing to night"
            gsettings set org.gnome.desktop.interface gtk-theme $GTK_THEME_NIGHT
            sed --follow-symlinks -i "s/^gtk-theme-name=.*/gtk-theme-name=$GTK_THEME_NIGHT/g"     $HOME/.config/gtk-3.0/settings.ini
            sed --follow-symlinks -i "s/^gtk-theme-name=.*/gtk-theme-name=\"$GTK_THEME_NIGHT\"/g" $HOME/.gtkrc-2.0
            sed --follow-symlinks -i '/# DynamicBackground/{n;s/.*/background-color=#ffffffDD/}' $HOME/.config/mako/config
            sed --follow-symlinks -i '/# DynamicForeground/{n;s/.*/text-color=#000000/}' $HOME/.config/mako/config
            sed --follow-symlinks -i 's/background = \"light\"/background = \"dark\"/g' $HOME/.config/nvim/lua/user/init.lua
            sed --follow-symlinks -i -E "s/(url.*)light/\1dark/g"    $HOME/.config/waybar/style.css 
            $HOME/.local/src/gogh/themes/google-dark.sh
            hyprctl --batch "keyword general:border_size 1 ; keyword decoration:inactive_opacity 0.65 ; keyword decoration:active_opacity 0.9 ; keyword general:col.active_border rgba(daa520dd)" 
            ;;
        esac
esac
makoctl reload
killall waybar; waybar &
