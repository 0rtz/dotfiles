# do not highlight pasted text
zle_highlight=('paste:none')

# show hidden files in completion
setopt globdots

# treat symbols as part of a word
WORDCHARS='*?$_-[]\&;.!#%^(){}<>|'

# disable ctrl-s in interactive shells
[[ -o interactive ]] && unsetopt flow_control

# vi mode
bindkey -v

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
