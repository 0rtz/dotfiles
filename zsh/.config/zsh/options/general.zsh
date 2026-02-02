# General shell options

# Do not highlight pasted text
zle_highlight=('paste:none')

# Treat symbols as part of a word
WORDCHARS='*?$_-[]\&;.!#%^(){}<>|'

# Enable vi mode
bindkey -v
KEYTIMEOUT=1

# Disable ctrl-s in interactive shells
[[ -o interactive ]] && unsetopt flow_control

# Show hidden files in completion
setopt globdots

# Allow comments in interactive shell
setopt INTERACTIVE_COMMENTS

# Disable terminal beep
setopt NO_BEEP