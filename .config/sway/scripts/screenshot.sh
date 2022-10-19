#!/bin/bash
 
entries="Active Screen Output Area Window"
 
selected=$(printf '%s\n' $entries | wofi --style=$HOME/.config/wofi/style.widgets.css --conf=$HOME/.config/wofi/config.screenshot | awk '{print tolower($1)}')
 
case $selected in
  active)
    /usr/share/sway/scripts/grimshot save active - | swappy -f -;;
  screen)
    /usr/share/sway/scripts/grimshot save screen - | swappy -f -;;
  output)
    /usr/share/sway/scripts/grimshot save output - | swappy -f -;;
  area)
    /usr/share/sway/scripts/grimshot save area - | swappy -f -;;
  window)
    /usr/share/sway/scripts/grimshot save window - | swappy -f -;;
esac
