#!/bin/bash

# Show how many windows are in scratchpad if not empty

if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
	count=$(hyprctl -j workspaces | jq '.[] | select(.name == "special:magic") | .windows // 0')
elif [ -n "$SWAYSOCK" ]; then
	count=$(swaymsg -t get_tree | jq 'recurse(.nodes[]) | first(select(.name=="__i3_scratch")) | .floating_nodes | length // 0')
fi

count=${count:-0}

if [[ "$count" -gt 0 ]]; then
	printf '{"text": "(%s)", "tooltip": "%s windows in scratchpad"}\n' "$count" "$count"
else
	printf '{"text": ""}\n'
fi
