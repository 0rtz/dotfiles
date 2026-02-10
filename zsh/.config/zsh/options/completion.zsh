# Completion system configuration

# Lazy compinit: rebuild once per day, otherwise reuse cached version
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit
else
	compinit -C
fi

# pipx completion (lazy-loaded on first completion attempt)
if (( ${+commands[pipx]} )); then
	_pipx_completion_loader() {
		unfunction _pipx_completion_loader
		autoload -U bashcompinit && bashcompinit
		eval "$(register-python-argcomplete pipx)"
		_normal
	}
	compdef _pipx_completion_loader pipx
fi

# Disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false

# Set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'

# Navigate completions with arrow keys
zstyle ':completion:*' menu select

# Case-insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Treat // as /
zstyle ':completion:*' squeeze-slashes true

# Set list-colors to enable filename colorizing during completion
# LS_COLORS is provided by trapd00r/LS_COLORS (loaded via zinit)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}