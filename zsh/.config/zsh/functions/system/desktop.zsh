function my-notify-wrapper() {
	if (( $# == 0 )); then
		echo "Usage: my-notify-wrapper <command> [args...]"
		return 1
	fi

	local start end elapsed exit_code
	start=$SECONDS

	"$@"
	exit_code=$?

	elapsed=$(( SECONDS - start ))

	# Format elapsed time as HH:MM:SS (portable)
	printf -v elapsed_fmt '%02d:%02d:%02d' \
		$((elapsed/3600)) \
		$(((elapsed%3600)/60)) \
		$((elapsed%60))

	if (( exit_code == 0 )); then
		notify-send -a "Terminal" \
			"Command finished successfully" \
			"$* took $elapsed_fmt"
	else
		notify-send -u critical -a "Terminal" \
			"Command failed (exit $exit_code)" \
			"$* took $elapsed_fmt"
	fi

	return $exit_code
}
compdef _command_names my-notify-wrapper

function my-yank-to-clipboard() {
	local copy_cmd paste_cmd

	if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
		copy_cmd=(wl-copy --trim-newline)
		paste_cmd=(wl-paste)
	else
		copy_cmd=(xclip -selection clipboard -in)
		paste_cmd=(xclip -selection clipboard -out)
	fi

	# Case 1: treat arguments as files/directories
	if (( $# > 0 )); then
		local files=()

		for path in "$@"; do
			if [[ -f "$path" ]]; then
				files+=("$path")
			elif [[ -d "$path" ]]; then
				files+=("${path}/**/*(.N)")
			else
				>&2 echo "ERROR: '$path' does not exist"
				return 1
			fi
		done

		(( ${#files[@]} == 0 )) && {
			>&2 echo "ERROR: No files to copy"
			return 1
		}

		cat -- "${files[@]}" | "${copy_cmd[@]}"

		print -l "Copied contents of:" "${files[@]}"
		return 0
	fi

	# Case 2: copy piped input from stdin
	if [[ -p /dev/stdin ]]; then
		local data
		data="$(cat)"

		print -n -- "$data" | "${copy_cmd[@]}"

		if (( $(grep -c . <<<"$data") > 1 )); then
			echo "Copied multiple lines to clipboard"
		else
			echo "Copied to clipboard: $data"
		fi
	fi
}