#!/usr/bin/env bash

# Copy current directory path to system clipboard
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
	printf "%s" "$PWD" | wl-copy
else
	printf "%s" "$PWD" | xclip -i -selection clipboard
fi
