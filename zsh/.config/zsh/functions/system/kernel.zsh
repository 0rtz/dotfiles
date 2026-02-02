function my-kernel-modules-fzf() {
	if ! (( ${+commands[fzf]} )) || ! (( ${+commands[modinfo]} )); then
		>&2 echo "ERROR: fzf and modinfo are required"
		return 1
	fi

	if ! (( ${+commands[lsmod]} )); then
		>&2 echo "ERROR: lsmod not found"
		return 1
	fi

	local selected_module
	selected_module=$(
		lsmod | fzf --header-lines=1 --prompt="Kernel module> " |
		awk '{print $1}'
	) || return

	[[ -z "$selected_module" ]] && return

	echo "Module: $selected_module"
	echo
	sudo modinfo "$selected_module"
}
