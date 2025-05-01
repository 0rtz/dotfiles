#!/bin/bash

if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
	if [[ $(hyprctl activewindow | grep -i -e "xwayland" | cut -d ':' -f 2 | grep -oP '\s\K[0-9]+') == "1" ]]; then
		DISPLAY_SERVER_TYPE="xwayland"
	fi
elif [ -n "$SWAYSOCK" ]; then
	DISPLAY_SERVER_TYPE=$(swaymsg -t get_tree | jq -r '.. | select(.type?) | select(.focused==true) | .shell')
fi

if [[ "$DISPLAY_SERVER_TYPE" == "xwayland" ]]; then
	echo "X11"
else
	echo ""
fi
