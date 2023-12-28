# do not highlight pasted text
zle_highlight=('paste:none')

# treat symbols as part of a word
WORDCHARS='*?$_-[]\&;.!#%^(){}<>|'

# vi mode
bindkey -v

# disable ctrl-s in interactive shells
[[ -o interactive ]] && unsetopt flow_control

# show hidden files in completion
setopt globdots

# man zshoptions(1)
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

# activate completion system
autoload -Uz compinit && compinit
# pipx completion
autoload -U bashcompinit
bashcompinit
eval "$(register-python-argcomplete pipx)"

# colored output
function _my-print-heading-blue() {
	print -P "%B%F{blue}$1%f%b"
}

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support (external command, builtin command, etc...)
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing during completion
export LS_COLORS='fi=0:di=34:ln=36:pi=33:so=35:bd=93:'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
