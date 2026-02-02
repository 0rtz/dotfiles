if [ "$(tty)" = "/dev/tty1" ]; then
	#if uwsm check may-start; then
		# Environment variables are stored in ~/.config/uwsm/env

		# Choose compositor to run:
		# exec uwsm start sway
		exec uwsm start hyprland
	#fi
fi
