# Add a git remote and fetch it immediately
function my-add-git-remote() {
	if [[ $1 == -h || $1 == --help || $# -lt 2 ]]; then
		echo "Usage: my-add-git-remote <remote_name> <url>"
		return
	fi

	git remote add "$1" "$2"
	git fetch "$1"
}