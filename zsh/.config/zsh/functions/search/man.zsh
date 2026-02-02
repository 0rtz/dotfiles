function my-man-fzf() {
	local selected=$(man -k . | fzf --preview 'echo {} | cut -d" " -f1 | xargs man' | cut -d' ' -f1)
	if [[ -n "$selected" ]]; then
		man "$selected"
	fi
}