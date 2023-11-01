##################################################
### widgets ######################################
##################################################

function my-widget-globalias() {
	zle _expand_alias
	zle self-insert
}
zle -N my-widget-globalias

function my-widget-magic-enter() {
	if [[ -z "$BUFFER" ]]; then
		if command git rev-parse --is-inside-work-tree &>/dev/null; then
			BUFFER="git status"
		else
			if command -v exa > /dev/null; then
				BUFFER="exa -aglbh --git --icons -F --color always"
			else
				BUFFER="ls -lAFh --color=tty"
			fi
		fi
	fi
	zle end-of-line
	zle accept-line
}
zle -N my-widget-magic-enter
# zsh-users/zsh-autosuggestions plugin
# clear suggestion string
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(my-widget-magic-enter)

function my-widget-toggle-sudo {
	if [[ $BUFFER != "sudo "* ]]; then
		BUFFER="sudo $BUFFER"; CURSOR+=5
	else
		BUFFER=$(echo "$BUFFER" | cut -d' ' -f2-)
	fi
	# 'jeffreytse/zsh-vi-mode'
	zvm_enter_insert_mode
}
zle -N my-widget-toggle-sudo

function my-copybuffer {
	if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
		printf "%s" "$BUFFER" | wl-copy
	else
		printf "%s" "$BUFFER" | xclip -i -selection clipboard
	fi
}
zle -N my-copybuffer

function my-pastebuffer {
	if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
		LBUFFER="$LBUFFER$(wl-paste)"
	else
		LBUFFER="$LBUFFER$(xclip -o -selection clipboard)"
	fi
	zle reset-prompt
}
zle -N my-pastebuffer

function my-widg-list-aliases() {
	declare -a res
	# collect array from alias command by newlines
	aliases_key=("${(@f)$(alias -r | cut -d'=' -f1)}")
	aliases_val=("${(@f)$(alias -r | cut -d'=' -f2-)}")
	aliases_key+=("${(@f)$(alias -g | cut -d'=' -f1)}")
	aliases_val+=("${(@f)$(alias -g | cut -d'=' -f2-)}")
	for ((i = 1; i <= $#aliases_key; i++)) do
		res[i]=$(printf '%s : %s\n' $aliases_key[i] $aliases_val[i])
	done
	local sel
	sel=$(printf '%s\n' "${res[@]}" | fzf --query="$LBUFFER" | awk -F" : " '{print $1}')
	if [[ ! -z "$sel" ]]; then
		LBUFFER="$sel"
	fi
}
zle -N my-widg-list-aliases

zle -N my-ripgrep-fzf

# edit current command in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line

##################################################
### zle keymaps ##################################
##################################################

function my-init-mappings() {
	bindkey -M viins "^t" edit-command-line
	bindkey -M viins "^ " magic-space
	bindkey -M viins "^y" my-copybuffer
	bindkey -M viins "^v" my-pastebuffer
	bindkey -M viins "^j" my-widget-magic-enter
	bindkey -M viins "^f" my-widg-list-aliases
	bindkey -M viins " " my-widget-globalias
	bindkey -M viins "^s" my-ripgrep-fzf
	# unbind tab
	bindkey -M viins -r '^i'
	# bind tab completion to 'Aloxaf/fzf-tab'
	bindkey -M viins "^k" fzf-tab-complete

	bindkey -M vicmd "s" my-widget-toggle-sudo
}
my-init-mappings
