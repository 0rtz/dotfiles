#!/usr/bin/env bash

# Copy file paths to system clipboard
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
	for path in "$@"; do
		echo "$path"
	done | wl-copy -t text/uri-list
else
	for path in "$@"; do
		echo "$path"
	done | xclip -i -selection clipboard -t text/uri-list
fi