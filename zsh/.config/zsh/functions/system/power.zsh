function my-powermenu() {
	op=$( echo -e " Hibernate\n Poweroff\n Reboot\n Lock" | fzf | awk '{print tolower($2)}' )
	case $op in
		hibernate)
			;&
		poweroff)
			;&
		reboot)
			systemctl $op
			;;
		lock)
			if (( ${+commands[hyprlock]} )) ; then
				hyprlock
			elif (( ${+commands[swaylock]} )) ; then
				swaylock --indicator-idle-visible
			fi
			return 1
			;;
	esac
}