# plugin manager: https://github.com/zdharma-continuum/zinit
# plugins location: $ZINIT[PLUGINS_DIR]
# Delete old(not sourced) plugins: zinit delete --clean
ZINIT_HOME="$HOME/.zsh/zinit"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

### create archives ###
zinit ice lucid wait'0'
zinit light 0rtz/mkarch

### CTRL-R shell history ###
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search
ZSH_FZF_HISTORY_SEARCH_END_OF_LINE=true
ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH=false
ZSH_FZF_HISTORY_SEARCH_REMOVE_DUPLICATES=true

### CTRL-R per directory history ###
# echo $HISTORY_BASE - per directory history dir
HISTORY_START_WITH_GLOBAL=true
zinit light jimhester/per-directory-history

### show tab-completion items with fzf ###
zinit light Aloxaf/fzf-tab
# use tmux popup to show results
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# a prefix to indicate the color. (set it to '' to activate ':completion:*:descriptions' format '[%d]')
zstyle ':fzf-tab:*' prefix ''
# switch groups
zstyle ':fzf-tab:*' switch-group 'ctrl-h' 'ctrl-l'
# additional mapping to pass to fzf
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-s:jump' 'ctrl-a:toggle-all'

### show autosuggestions as-you-type ###
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(backward-kill-line)
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8,bold"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

### auto-instert pairs ###
zinit ice wait"1" lucid # loading is done 1 second after prompt (hide Loaded message)
zinit light hlissner/zsh-autopair

### git with fzf ###
export FORGIT_NO_ALIASES=true
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
	export FORGIT_COPY_CMD='wl-copy'
else
	export FORGIT_COPY_CMD='xclip -i -selection clipboard'
fi
export FORGIT_FZF_DEFAULT_OPTS="--bind ctrl-s:jump"
zinit ice lucid wait'0'
zinit load wfxr/forgit

### highlight shell syntax ###
zinit light zdharma-continuum/fast-syntax-highlighting

### theme ###
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

### vi-mode ###
ZVM_VI_ESCAPE_BINDKEY=kj
zinit light jeffreytse/zsh-vi-mode
# normal/visual mode mappings
function my_zvm_after_lazy_keybindings() {
	zvm_bindkey vicmd 'H' beginning-of-line
	zvm_bindkey vicmd 'L' end-of-line
	zvm_bindkey visual 'v' zvm_exit_visual_mode
	zvm_bindkey visual 'x' zvm_vi_delete
	# overwrite jeffreytse/zsh-vi-mode keymaps
	bindkey -M vicmd 's' my-widget-toggle-sudo
	bindkey -M vicmd 'k' up-line
	bindkey -M vicmd 'j' down-line
	bindkey -M visual 'k' up-line
	bindkey -M visual 'j' down-line
}
# execute commands when first entering normal mode (shell started with insert mode)
zvm_after_lazy_keybindings_commands+=(my_zvm_after_lazy_keybindings)
function my_zvm_after_init() {
	my-init-mappings
	# insert mode mappings
	# need ^U as backward-kill-line in order for ZSH_AUTOSUGGEST_CLEAR_WIDGETS to clear prompt
	bindkey -M viins '^U' backward-kill-line
}
zvm_after_init_commands+=(my_zvm_after_init)
