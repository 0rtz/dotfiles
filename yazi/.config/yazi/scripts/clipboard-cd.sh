#!/usr/bin/env bash

# Change directory to a path read from system clipboard
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
	DIR=$(wl-paste)
else
	DIR=$(xclip -o -selection clipboard)
fi
# Expand ~ and $HOME
# shellcheck disable=SC2016
case "$DIR" in
	"~"*) DIR="$HOME${DIR#"~"}" ;;
	'$HOME'*) DIR="$HOME${DIR#'$HOME'}" ;;
esac
# Resolve relative paths
case "$DIR" in
	/*) ;; # absolute, keep as-is
	*) DIR="$PWD/$DIR" ;;
esac
ya emit cd "$DIR"