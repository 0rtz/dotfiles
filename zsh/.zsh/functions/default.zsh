function my-yank-to-clipboard() {
	# if arguments were specified treat it as file names
	if [ $# -gt 0 ]; then
		local file_list=()
		for file in $@; do
			if [[ -d $file ]]; then
				for entry in $file/**/*(.);
				do
					file_list+="$entry"
				done
			elif [[ -f $file ]]; then
				file_list+="$file"
			else
				>&2 echo -e "\nERROR. File $file does not exist. Exiting..."; return 1
				return 1
			fi
		done
		if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
			wl-copy --trim-newline < $file_list
		else
			xclip -rmlastnl -selection clipboard $file_list
		fi
		print -l "files:\n" "$file_list[@]" "\ncontent copied to clipboard"
	else
		# if data was piped copy it from stdin
		if [ -p /dev/stdin ];then
			local data=""
			local stdin=$(</dev/stdin)
			if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
				echo -n "$stdin" | wl-copy
				data="$(wl-paste)"
			else
				echo -n "$stdin" | xclip -in -selection clipboard
				data="$(xclip -out -selection clipboard)"
			fi
			if [ "$data" != "" ]; then
				if (( $(grep -c . <<<"$data") > 1 )); then
					echo -e "$data\n\ncopied to clipboard"
				else
					echo -e "$data copied to clipboard"
				fi
			fi
		fi
	fi
}

function n() {
	# Block nesting of nnn in subshells
	if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
		echo "nnn is already running"
		return
	fi

	# -c) cli‐only opener ($NNN_OPENER)
	# -a) multiple NNN_FIFO for previewers
	# -H) show hidden files by default
	# -T 't') sort by time accessed by default
	# -i) show current file info in info bar
	# -U) show user and group names
	# -g) fuzzy(regex) file search match
	# -A) do not open dir if is the only match in search
	# -Q) no quit confirmation on <Ctrl-G>
	nnn -c -a -H -T 't' -i -U -g -A -Q "$@"

	# cd on quit
	if [ -f "$NNN_TMPFILE" ]; then
			. "$NNN_TMPFILE"
			rm -f "$NNN_TMPFILE" > /dev/null
	fi
}

function my-editor-open () {
	if [ $# -eq 0 ]; then
		$EDITOR
	else
		if echo $1 | grep -q -E ":[[:digit:]]+$"; then
			local filename=$(echo $1 | cut -d':' -f1)
			local line=$(echo $1 | cut -d':' -f2)
			$EDITOR +${line} ${filename}
		else
			if [ ! -f $1 ]; then
				local dir=$(dirname $1)
				if [[ ! -d $dir ]]; then
					mkdir -p ${dir}
					echo "Created $dir"
				fi
				touch $1
			else
				local size
				size=$(wc -c < $1)
				if (( size > 1000000 )); then
					nvim -u NONE $1
					return
				fi
			fi
			$EDITOR $1
		fi
	fi
}

function my-create-edit-tmp() {
	local TMP=$(mktemp)
	$EDITOR ${TMP}
	echo ${TMP}
}

function my-create-script() {
	local file=$1
	if [ ! -e "$file" ]; then
		if [ -z "$file" ]; then
			file="$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 8)"
		fi
		# zshexpn(1): HISTORY EXPANSION -> Modifiers
		file=$file:t
		if [[ -z "$file:e" ]]; then
			file="$file".sh
		fi
		echo -e '#!/bin/bash\n\n' > "$file"
		chmod +x $file
		$EDITOR + "$file"
		echo "$file created"
	else
		my-editor-open "$file"
	fi
}

function my-eval-var() {
	echo -e "cmd:\n\n******************************\n${(P)1}\n******************************\n"
	if read -q "choice?Execute: y/n? "; then
		echo
		eval "${(P)1}"
	else
		print "\nAborting..."
	fi
}
compdef _vars my-eval-var

function my-tmux-session-create-run-cmd()
{
	if [[ "$#" -eq 0 ]]; then
		>&2 echo -e "\nERROR. Specify command to run. Exiting..."; return 1
	fi
	SESSION_NAME=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 8)
	tmux new-session -d -s $SESSION_NAME
	tmux send-keys -t $SESSION_NAME.0 "$@" C-m
	if [[ -z "${TMUX}" ]]; then
		tmux attach-session -t $SESSION_NAME
	else
		echo "Session $SESSION_NAME created"
	fi
}
compdef _path_commands my-tmux-session-create-run-cmd

function my-processes-search() {
	if [[ -z $1 ]]; then
		>&2 echo -e "ERROR: Specify PID or process name. Exiting..."
		return 1
	fi
	local regex_number='^[0-9]+$'
	if [[ $1 =~ $regex_number ]] ; then
		OUT=$(ps -wwo "pid,wchan,cmd" -p $1)
	else
		OUT=$(ps -wwo "pid,wchan,cmd" -p $(pgrep $1))
	fi
	if [[ $? -gt 0 ]]; then
		return 1
	fi
	echo "$OUT"
}
compdef my-processes-search=pgrep

function my-replace-recursive() {
	if command -v "sd" > /dev/null 2>&1 ; then
		if [[ $# -ne 2 ]]; then
			>&2 echo -e "ERROR: Specify OLD and NEW string. Exiting..."
			return 1
		fi
		local str1="$1"
		local str2="$2"
		find . -type f -exec sd --preview "$1" "$2" {} +
		find . -type f -exec sd "$1" "$2" {} +
	fi
}

function my-delay-wrapper() {
	usage="
Usage: $(basename "$0") timeout CMD...
Execute 'CMD...' after 'timeout'
	"
	while [[ $# -gt 0 ]]; do
		case $1 in
			-h|--help)
				echo "${usage}"
				return
			;;
			*)
				POSITIONAL_ARGS+=("$1") # save positional arg
				shift
			;;
		esac
	done
	# restore arguments
	set -- "${POSITIONAL_ARGS[@]}"
	sleep $1
	echo "Executing ${@:2}"
	"${@:2}"
}
compdef _command_names my-delay-wrapper
