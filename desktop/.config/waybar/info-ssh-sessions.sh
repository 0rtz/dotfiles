#!/bin/sh

sessions="$(ss | grep ssh)"

if [ -n "$sessions" ]; then
	count=$(echo "$sessions" | wc -l)
	echo "󰒍($count)"
else
	echo ""
fi
