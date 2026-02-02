function my-eval-var() {
	if [[ -z "$1" ]]; then
		echo "Usage: my-eval-var <variable-name>"
		return 1
	fi

	if ! typeset -p "$1" &>/dev/null; then
		>&2 echo "ERROR: Variable '$1' does not exist"
		return 1
	fi

	local cmd="${(P)1}"

	if [[ -z "$cmd" ]]; then
		>&2 echo "ERROR: Variable '$1' is empty"
		return 1
	fi

	print -r -- "cmd:"
	print -r -- "******************************"
	print -r -- "$cmd"
	print -r -- "******************************"
	echo

	if ! read -q "?Execute? (y/n): "; then
		echo "\nAborting..."
		return 1
	fi
	echo
	echo

	eval "$cmd"
}
compdef _vars my-eval-var