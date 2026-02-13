# yazi file manager wrapper with cd-on-quit support
# https://github.com/sxyazi/yazi

function n() {
	# Do nothing if already inside Yazi
	if [[ -n "$YAZI_LEVEL" && "$YAZI_LEVEL" -ge 1 ]]; then
		print "Already inside yazi"
		return 0
	fi

	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}