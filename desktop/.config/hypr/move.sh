#!/bin/bash

# Decides whether to issue 'movewindoworgroup' or 'movegroupwindow' when moving left or right to emulate sway/i3 behaviour

WINDOW_INFO=$(hyprctl -j activewindow)
GROUP_WINDOWS_IDS=$(echo "$WINDOW_INFO" | jq '.grouped')
GROUP_LENGTH=$(echo "$WINDOW_INFO" | jq '.grouped | length')
CURRENT_WINDOW_ID=$(echo "$WINDOW_INFO" | jq '.address')
CURRENT_WINDOW_INDEX=$(echo "$GROUP_WINDOWS_IDS" | jq "index($CURRENT_WINDOW_ID)")

echo "GROUP_WINDOWS_IDS: $GROUP_WINDOWS_IDS"
echo "CURRENT_WINDOW: $CURRENT_WINDOW_ID"
echo "CURRENT_WINDOW index: $CURRENT_WINDOW_INDEX"

if [[ "$1" == "r" ]]; then
	if [[ $((CURRENT_WINDOW_INDEX + 1)) -eq $GROUP_LENGTH ]]; then
		# we are in the rightmost window in a group and need to move right => move out of group
		hyprctl dispatch movewindoworgroup "$1"
	else
		hyprctl dispatch movegroupwindow f
	fi
elif [[ "$1" == "l" ]]; then
	if [[ $CURRENT_WINDOW_INDEX -eq 0 ]]; then
		# we are in the leftmost window in a group and need to move left => move out of group
		hyprctl dispatch movewindoworgroup "$1"
	else
		hyprctl dispatch movegroupwindow b
	fi
fi
