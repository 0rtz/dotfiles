function my-notfiy-wrapper() {
	start=$(date +%s)
	"$@"
	if command -v notify-send > /dev/null; then
		notify-send "Command \"$(echo $@)\" completed" "duration: $(($(date +%s) - start)) seconds"
	fi
}

function my-delay-wrapper() {
	sleep $1
	echo "Executing ${@:2}"
	"${@:2}"
}
