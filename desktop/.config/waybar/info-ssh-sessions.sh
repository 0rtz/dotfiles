#!/bin/sh

sessions="$(ls /tmp/.ssh_* 2>/dev/null || true)"

if [ -n "$sessions" ]; then
	count=$(echo "$sessions" | wc -l)
	echo "󰒍($count)"
else
	echo ""
fi
