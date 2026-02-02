# nnn file manager wrapper with cd-on-quit support

function n() {
	# Prevent nesting nnn in subshells
	if (( ${NNNLVL:-0} >= 1 )); then
		echo "nnn is already running"
		return
	fi

	# Options:
	#   -c  cli-only opener (uses $NNN_OPENER)
	#   -a  multiple NNN_FIFO for previewers
	#   -H  show hidden files
	#   -T  sort by time accessed
	#   -i  show file info in status bar
	#   -U  show user/group names
	#   -g  fuzzy/regex search
	#   -A  don't auto-open single search match
	#   -Q  no quit confirmation on Ctrl-G
	nnn -c -a -H -T 't' -i -U -g -A -Q "$@"

	# cd to last visited directory on quit
	if [[ -f "$NNN_TMPFILE" ]]; then
		source "$NNN_TMPFILE"
		rm -f "$NNN_TMPFILE"
	fi
}