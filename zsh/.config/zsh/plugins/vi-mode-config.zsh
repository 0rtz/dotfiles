# 'jeffreytse/zsh-vi-mode' plugin configuration

ZVM_VI_ESCAPE_BINDKEY=kj

# Normal/visual mode mappings only
function my_zvm_after_lazy_keybindings() {
	zvm_bindkey vicmd 'H' beginning-of-line
	zvm_bindkey vicmd 'L' end-of-line
	zvm_bindkey vicmd 's' zle-widget::my-widget-toggle-sudo
	zvm_bindkey vicmd 'k' up-line
	zvm_bindkey vicmd 'j' down-line
	zvm_bindkey visual 'v' zvm_exit_visual_mode
	zvm_bindkey visual 'x' zvm_vi_delete
	zvm_bindkey visual 'k' up-line
	zvm_bindkey visual 'j' down-line
}
# Execute commands when first entering normal mode (shell started with insert mode)
zvm_after_lazy_keybindings_commands+=(my_zvm_after_lazy_keybindings)

# Insert mode mappings
function my_zvm_after_init() {
	my-init-mappings
	# Need ^U as backward-kill-line in order for ZSH_AUTOSUGGEST_CLEAR_WIDGETS to clear prompt
	bindkey -M viins '^U' backward-kill-line
}
zvm_after_init_commands+=(my_zvm_after_init)