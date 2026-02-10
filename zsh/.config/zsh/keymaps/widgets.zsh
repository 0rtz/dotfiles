# Register functions as zle widgets to use in bindings

function zle-widget::my-widget-globalias() {
	zle _expand_alias
	zle self-insert
}
zle -N zle-widget::my-widget-globalias

# :: has zero semantic meaning for zsh
function zle-widget::my-widget-magic-enter() {
	if [[ -n $BUFFER ]]; then
		zle accept-line
		return
	fi

	if git rev-parse --is-inside-work-tree &>/dev/null; then
		BUFFER="git status"
	elif (( $+commands[eza] )); then
		BUFFER="eza -aglbh --git --icons -F --color always"
	else
		BUFFER="ls -lAFh --color=tty"
	fi

	zle end-of-line
	zle accept-line
}
zle -N zle-widget::my-widget-magic-enter

function zle-widget::my-widget-toggle-sudo {
	if [[ $BUFFER != "sudo "* ]]; then
		BUFFER="sudo $BUFFER"; CURSOR+=5
	else
		BUFFER="${BUFFER#sudo }"
	fi
	# 'jeffreytse/zsh-vi-mode'
	zvm_enter_insert_mode
}
zle -N zle-widget::my-widget-toggle-sudo

function zle-widget::my-copybuffer {
	(( $+commands[wl-copy] )) || (( $+commands[xclip] )) || return 1

	if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
		printf "%s" "$BUFFER" | wl-copy
	else
		printf "%s" "$BUFFER" | xclip -i -selection clipboard
	fi
}
zle -N zle-widget::my-copybuffer

function zle-widget::my-pastebuffer {
	(( $+commands[wl-paste] )) || (( $+commands[xclip] )) || return 1

	if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
		LBUFFER="$LBUFFER$(wl-paste)"
	else
		LBUFFER="$LBUFFER$(xclip -o -selection clipboard)"
	fi
	zle reset-prompt
}
zle -N zle-widget::my-pastebuffer

function zle-widget::my-widg-list-aliases() {
	declare -a res
	# collect array from alias command by newlines
	aliases_key=(${(k)aliases})
	aliases_val=(${(v)aliases})
	for ((i = 1; i <= $#aliases_key; i++)) do
		res[i]=$(printf '%s : %s\n' $aliases_key[i] $aliases_val[i])
	done
	local sel
	sel=$(printf '%s\n' "${res[@]}" | fzf --query="$LBUFFER" | awk -F" : " '{print $1}')
	if [[ -n "$sel" ]]; then
		LBUFFER="$sel"
	fi
}
zle -N zle-widget::my-widg-list-aliases

zle -N my-ripgrep-fzf

# Edit current command in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line