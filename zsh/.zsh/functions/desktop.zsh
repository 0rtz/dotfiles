function my-notfiy-wrapper() {
	start=$(date +%s)
	"$@"
	if command -v notify-send > /dev/null; then
		notify-send "Command \"$(echo $@)\" completed" "duration: $(($(date +%s) - start)) seconds"
	fi
}
compdef _command_names my-notfiy-wrapper

function my-vscode-open () {
	if [ $# -eq 0 ]; then
		if command -v "windsurf" > /dev/null 2>&1 ; then
			windsurf . &!
		elif command -v "code" > /dev/null 2>&1 ; then
			code .
		else
			my-editor-open
		fi
	else
		local size
		size=$(wc -c < $1)
		if (( size > 1000000 )); then
			nvim -u NONE $1
			return
		fi
		if command -v "windsurf" > /dev/null 2>&1 ; then
			windsurf --goto $1 &!
		elif command -v "code" > /dev/null 2>&1 ; then
			code --goto $1
		else
			my-editor-open $1
		fi
	fi
}
