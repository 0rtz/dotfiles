#!/bin/sh

if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
	updates_arch=0
fi

all_count=$(pacman -Q  | wc -l)
threshold=$((20 * all_count / 100))

if [ "$updates_arch" -gt "$threshold" ]; then
	echo "($updates_arch)"
else
	echo ""
fi
