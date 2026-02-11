function my-processes-search() {
	if [[ $1 == -h || $1 == --help ]]; then
		echo "Usage: my-processes-search [pid|process_name]"
		return 0
	fi

	local pid

	if [[ -z $1 ]]; then
		pid=$(
			ps -ww -eo user,pid,ppid,%cpu,%mem,etime,cmd --sort=-%mem |
			fzf --header-lines=1 --reverse
		) || return

		pid=$(echo "$pid" | awk '{print $2}')
	else
		local regex_number='^[0-9]+$'
		if [[ $1 =~ $regex_number ]] ; then
			pid=$1
		else
			pid=$(pgrep "$1")
		fi
	fi
	[[ -z "$pid" ]] && return

	echo -n "$pid" | my-yank-to-clipboard
	ps -ww -p "$pid" -o pid,ppid,%cpu,%mem,etime,args
}
compdef my-processes-search=pgrep

function my-shared-libs-fzf() {
	local lib

	lib=$(
		ldconfig -p |
		grep -E '^\s+\S+' |
		sed -n 's/^\s*\([^ ]*\).*/\1/p' |
		sort -u |
		fzf --prompt="Shared library> "
	) || return

	echo "Processes using $lib:"
	for pid in /proc/[0-9]*; do
		grep -q "$lib" "$pid/maps" 2>/dev/null &&
			printf "%s %s\n" "$(basename "$pid")" "$(ps -p "$(basename "$pid")" -o comm=)"
	done | sort -u
}

function my-delay-wrapper() {
	if [[ -z "$1" || "$1" != <-> ]]; then
		echo "Usage: my-delay-wrapper <seconds> <command> [args...]"
		return 1
	fi

	local delay="$1"
	shift

	if (( $# == 0 )); then
		>&2 echo "ERROR: No command specified"
		return 1
	fi

	(
		sleep "$delay"
		"$@"
	) &
	disown

	echo "Scheduled in $delay seconds: $*"
}
compdef _command_names my-delay-wrapper