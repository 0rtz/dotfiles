#!/usr/bin/env bash

# Copy file paths to system clipboard
result=""
for path in "$@"; do
	[ -n "$result" ] && result="$result\n"
	result="$result$path"
done
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
	printf "%b" "$result" | wl-copy
else
	printf "%b" "$result" | xclip -i -selection clipboard
fi
