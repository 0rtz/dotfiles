# Called by 'jeffreytse/zsh-vi-mode'
function my-init-mappings() {
	bindkey -M viins "^y" zle-widget::my-copybuffer
	bindkey -M viins "^v" zle-widget::my-pastebuffer
	bindkey -M viins "^j" zle-widget::my-widget-magic-enter
	bindkey -M viins "^f" zle-widget::my-widg-list-aliases
	bindkey -M viins " " zle-widget::my-widget-globalias
	bindkey -M viins "^s" my-ripgrep-fzf
	bindkey -M viins "^t" edit-command-line
	bindkey -M viins "^ " magic-space
	# unbind tab
	bindkey -M viins -r '^i'
	# bind tab completion to 'Aloxaf/fzf-tab'
	bindkey -M viins "^k" fzf-tab-complete
}