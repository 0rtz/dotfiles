# Zinit plugin manager
declare -A ZINIT
ZINIT[HOME_DIR]="${ZDOTDIR:-$HOME/.config/zsh}/zinit"
ZINIT[COMPLETIONS_DIR]="${ZINIT[HOME_DIR]}/completions"
[[ -d "${ZINIT[HOME_DIR]}" ]] || { echo "Error: Zinit directory not found at ${ZINIT[HOME_DIR]}" >&2; return 1; }
source "${ZINIT[HOME_DIR]}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

### CTRL-R shell history ###
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search
ZSH_FZF_HISTORY_SEARCH_END_OF_LINE=true
ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH=false
ZSH_FZF_HISTORY_SEARCH_REMOVE_DUPLICATES=true

### Show tab-completion items with fzf ###
zinit light Aloxaf/fzf-tab
# Use tmux popup to show results
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# Remove leading '.' from completion items
zstyle ':fzf-tab:*' prefix ''
# Switch groups
zstyle ':fzf-tab:*' switch-group 'ctrl-h' 'ctrl-l'
# Additional mappings to pass to fzf
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-s:jump' 'ctrl-a:toggle-all'

### Autosuggest command completion ###
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8,bold"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
zinit light zsh-users/zsh-autosuggestions
# Clear suggestion string
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(my-widget-magic-enter backward-kill-line)

### Auto-insert pairs ###
# Loading is done 1 second after prompt to hide "Loaded hlissner/zsh-autopair" on shell start
zinit ice wait"1" lucid
zinit light hlissner/zsh-autopair

### Git with fzf ###
export FORGIT_NO_ALIASES=true
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
	export FORGIT_COPY_CMD='wl-copy'
else
	export FORGIT_COPY_CMD='xclip -i -selection clipboard'
fi
export FORGIT_FZF_DEFAULT_OPTS="--bind ctrl-s:jump"
zinit ice lucid wait'0'
zinit load wfxr/forgit

### Highlight shell syntax ###
# Must be loaded last
zinit ice lucid wait'0'
zinit light zdharma-continuum/fast-syntax-highlighting

### Theme ###
# git clone depth = 1
zinit ice depth"1"
zinit light romkatv/powerlevel10k

### Enhanced Vim mode ###
zinit light jeffreytse/zsh-vi-mode