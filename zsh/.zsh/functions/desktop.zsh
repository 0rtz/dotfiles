function my-notfiy-wrapper() {
	start=$(date +%s)
	"$@"
	if command -v notify-send > /dev/null; then
		notify-send "Command \"$(echo $@)\" completed" "duration: $(($(date +%s) - start)) seconds"
	fi
}

function my-pick-color() {
	grim -g "$(slurp -p)" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:- | tail -n 1 | cut -d ' ' -f 4
}
