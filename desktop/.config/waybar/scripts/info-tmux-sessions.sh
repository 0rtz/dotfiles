#!/bin/bash

if sessionlist=$(tmux ls 2>/dev/null); then
	session_count=0
	attached_count=0

	while read -r line; do
		session_count=$((session_count + 1))
		if echo "$line" | grep -q "(attached)"; then
			attached_count=$((attached_count + 1))
		fi
	done < <(echo "$sessionlist")

	tooltip=$(echo "$sessionlist" | sed 's/"/\\"/g' | tr '\n' '\\' | sed 's/\\/\\n/g' | sed 's/\\n$//')
	printf '{"text": "(%s/%s)", "tooltip": "%s"}\n' "$attached_count" "$session_count" "$tooltip"
else
	printf '{"text": ""}\n'
fi
