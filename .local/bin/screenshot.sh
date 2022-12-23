#!/bin/bash
set -eu

## FROM https://raw.githubusercontent.com/yschaeff/sway_screenshots/master/screenshot.sh

## USER PREFERENCES ##
#MENU="dmenu -i"
MENU="rofi -i -dmenu"
RECORDER=wf-recorder
TARGET=$(xdg-user-dir PICTURES)/screenshots
TARGET_VIDEOS=$(xdg-user-dir PICTURES)/screencasts
#NOTIFY=$(pidof mako || pidof dunst) || true
NOTIFY=true
FOCUSED=$(swaymsg -t get_tree | jq '.. | ((.nodes? + .floating_nodes?) // empty) | .[] | select(.focused and .pid) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
OUTPUTS=$(swaymsg -t get_outputs | jq -r '.[] | select(.active) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
WINDOWS=$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
REC_PID=$(pidof $RECORDER) || true
echo $REC_PID

# recoding filename temp file.
REC_TMP_FILE="/tmp/__screenrecording_filename__.txt"

FILENAME="$TARGET/$(date +'%Y%m%d_%H%M%S_screenshot.png')"
GIF_FILENAME="$(date +'%Y%m%d_%H%M%S_recording.gif')"
RECORDING_FILENAME="$(date +'%Y%m%d_%H%M%S_recording.mp4')"
RECORDING="${TARGET_VIDEOS}/${RECORDING_FILENAME}"
RECORDING_GIF="${TARGET_VIDEOS}/${GIF_FILENAME}"

# make sure directory exists
mkdir -p $TARGET
mkdir -p $TARGET_VIDEOS

# 12x6+0.5+0 GIMP
# -unsharp 10x5+0.7+0 よき
# -unsharp 2x1.4+0.5+0 ぼやける
#CONVERT_OPTS="-unsharp 12x6+0.5+0 -quality 100"
# https://qiita.com/yoya/items/b1590de289b623f18639
CONVERT_OPTS="-colorspace RGB -filter Lanczos -define filter:blur=.9891028367558475 -colorspace sRGB"

notify() {
    ## if the daemon is not running notify-send will hang indefinitely
    if [ $NOTIFY ]; then
        notify-send "$@"
    else
        echo NOTICE: notification daemon not active
        echo "$@"
    fi
}

notify-rec() {
    notify "Screen Recording" "Target: $1"
    rm -f $REC_TMP_FILE
    shopt -s nocasematch
    if [[ "$1" =~ gif$ ]]; then
        echo "$GIF_FILENAME" > $REC_TMP_FILE
    else
        echo "$RECORDING_FILENAME" > $REC_TMP_FILE
    fi
    shopt -u nocasematch
}

if [ ! -z $REC_PID ]; then
    echo "pid: $REC_PID"
    kill -SIGINT $REC_PID
    
    if [ -e $REC_TMP_FILE ]; then
        REC_FILENAME=`cat $REC_TMP_FILE`
        notify "End Recoding" "Recorded: \n$REC_FILENAME" -t 2000
    else
        notify "End Recoding" "Recorded" -t 2000
    fi

    exit 0
fi

# Added
echo $#
if [ $# == 0 ]; then

DELAY=`$MENU -l 5 -p "Delay?" -select "0" << EOF
0
1
5
10
20
EOF`
echo "Show menu"
# -l is number of lines
# -a is active (blue text) -u is urgent (red background)
CHOICE=`$MENU -l 15 -a 0,1,2,3,4,5,6,7,8 -u 9,10,11,12,13 -p "Record" -select "Fullscreen" << EOF
Fullscreen
Focused
Select-window
Select-output
Region
Region-Flameshot
Region-Resize-Half
Region-Resize-25percent
Color-Picker
Record-focused
Record-select-window
Record-select-output
Record-region
Record-region-gif
EOF`
else
  echo "From param $1"
  CHOICE=$1
fi

case "$CHOICE" in
    "Fullscreen")
        sleep $DELAY && /usr/bin/grimshot save output - | swappy -f -;;
    "Region")
        sleep $DELAY && /usr/bin/grimshot save area - | swappy -f -;;
    "Region-Flameshot")
        XDG_CURRENT_DESKTOP=sway /usr/bin/flameshot gui -d $((DELAY * 1000));;
    "Region-Resize-Half")
        sleep $DELAY && slurp | grim -g - "$FILENAME"
        ORG_FILENAME=$FILENAME
        FILENAME=${TARGET}/`basename ${FILENAME} .png`-half.png
        convert $ORG_FILENAME $CONVERT_OPTS -distort Resize 50% $FILENAME
        rm $ORG_FILENAME
        swappy -f $FILENAME
        ;;
    "Region-Resize-25percent")
        sleep $DELAY && slurp | grim -g - "$FILENAME"
        ORG_FILENAME=$FILENAME
        FILENAME=${TARGET}/`basename ${FILENAME} .png`-25.png
        convert $ORG_FILENAME $CONVERT_OPTS -distort Resize 25% $FILENAME
        rm $ORG_FILENAME
        swappy -f $FILENAME
        ;;
    "Select-window")
        sleep $DELAY && /usr/bin/grimshot save window - | swappy -f -;;
    "Focused")
        sleep $DELAY && /usr/bin/grimshot save active - | swappy -f -;;
    "Color-Picker")
        COLOR=`hyprpicker`
        echo "$COLOR picked"
        echo $COLOR | wl-copy
        notify "Color Picker" "Color picked is ${COLOR}\nCopied to clipboard" -t 6000
        exit;;
    "Record-select-output")
        sleep $DELAY && $RECORDER -g "$(echo "$OUTPUTS"|slurp)" -f "$RECORDING" &
        notify-rec "Display"
        REC=1 ;;
    "Record-select-window")
        sleep $DELAY && PARAM="$(echo "$WINDOWS"|slurp)"
        $RECORDER -g "$(echo "$WINDOWS"|slurp)" -f "$RECORDING" &
        notify-rec "Window"
        REC=1 ;;
    "Record-region")
        sleep $DELAY && PARAM="$(slurp)"
        $RECORDER -g "${PARAM}" -f "$RECORDING" &
        notify-rec "Region"
        REC=1 ;;
    "Record-region-gif")
        sleep $DELAY && PARAM="$(slurp)"
        $RECORDER -g "${PARAM}" -F fps=21 -c gif -f "$RECORDING_GIF" &
        notify-rec "Region as Gif"
        REC=1 ;;
    "Record-focused")
        sleep $DELAY && $RECORDER -g "$(eval echo $FOCUSED)" -f "$RECORDING" &
        notify-rec "Focused"
        REC=1 ;;
    *)
        sleep $DELAY && grim -g "$(eval echo $CHOICE)" "$FILENAME" ;;
esac
if [ $REC ]; then
    echo "rec start"
else
    notify "Screenshot saved" "File saved as \n$FILENAME\nand copied to clipboard" -t 6000 -i $FILENAME
    wl-copy < $FILENAME
    # feh $FILENAME
fi 
