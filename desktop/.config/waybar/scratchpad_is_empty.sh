#!/bin/bash

# if scratchpad not empty => show how many windows in scratchpad

if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
	hyprctl -j workspaces | jq '.[] | (select(.name == "special:magic")) | .windows'
elif [ -n "$SWAYSOCK" ]; then
	swaymsg -t get_tree | jq 'recurse(.nodes[]) | first(select(.name=="__i3_scratch")) | .floating_nodes | length | select(. >= 1)'
fi
