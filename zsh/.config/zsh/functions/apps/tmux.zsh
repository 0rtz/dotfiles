# Create a detached tmux session running a command
# Usage: my-tmux-session-create-run-cmd <session_name> <command...>
function my-tmux-session-create-run-cmd() {
	local session_name="$1"
	shift
	local command="$*"

	if [[ -z "$session_name" || -z "$command" ]]; then
		echo "Usage: my-tmux-session-create-run-cmd <session_name> <command>"
		return 1
	fi

	tmux new-session -d -s "$session_name" "$command"
	echo "Created tmux session '$session_name' running: $command"
}
