# Do not highlight pasted text
zle_highlight=('paste:none')

# Treat symbols as part of a word
WORDCHARS='*?$_-[]\&;.!#%^(){}<>|'

# vi mode
bindkey -v

# Disable ctrl-s in interactive shells
[[ -o interactive ]] && unsetopt flow_control

# Show hidden files in completion
setopt globdots

# man zshoptions(1)
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE=$HOME/.zsh_history

# Activate completion system
autoload -Uz compinit && compinit
# pipx completion
autoload -U bashcompinit
bashcompinit
eval "$(register-python-argcomplete pipx)"

# Colored output
function _my-print-heading-blue() {
	print -P "%B%F{blue}$1%f%b"
}

# Disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# Set descriptions format to enable group support (external command, builtin command, etc...)
zstyle ':completion:*:descriptions' format '[%d]'
# Set list-colors to enable filename colorizing during completion
export LS_COLORS='fi=0:di=34:ln=36:pi=33:so=35:bd=93:'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Environment variables used by programs:
typeset -U path
path+=($HOME/bin $HOME/usr/bin)
path+=($HOME/.local/bin $HOME/.cargo/bin $HOME/go/bin $HOME/npm/bin)
if command -v ruby > /dev/null; then
	path+=($(ruby -r rubygems -e 'puts Gem.user_dir')/bin)
fi
export PATH
typeset -U fpath
fpath=(~/.zsh.d/ $fpath)
export FPATH
export XDG_CONFIG_HOME=$HOME/.config
export LANG=en_US.UTF-8
export EDITOR='nvim'
export PAGER='less -R'
# ssh-agent:
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
# fuzzy finder:
export FZF_DEFAULT_OPTS="-m \
--bind ctrl-d:preview-page-down,\
ctrl-u:preview-page-up,\
ctrl-s:jump,\
ctrl-space:toggle,\
ctrl-a:toggle-all,\
'ctrl-v:transform-query:echo -n {q}; if [ \"\$XDG_SESSION_TYPE\" = \"wayland\" ]; then wl-paste; else xclip -o -selection clipboard; fi'"
export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git"'
export COLUMNS
export FZF_PREVIEW_COLUMNS
# nnn file manager:
export NNN_INCLUDE_HIDDEN=1
NNN_PLUG_BUNDLED='f:fzcd;p:preview-tui;r:gitroot;n:fixname;D:diffs'
NNN_PLUG_CMDS='s:-!sudoedit "$nnn"*;g:-!neovide "$nnn" >/dev/null 2>&1 & disown*'
NNN_PLUG_YANK='y:-nnn_file_path_yank;Y:-nnn_file_name_yank;d:-nnn_file_dir_yank'
NNN_PLUG_CD='c:nnn_clipboard_file_path_cd'
export NNN_PLUG="$NNN_PLUG_BUNDLED;$NNN_PLUG_CMDS;$NNN_PLUG_YANK;$NNN_PLUG_CD;"
MY_NNN_TMP=$(mktemp -d)
export NNN_BMS="\
d:$HOME/.dotfiles;c:$HOME/.config;n:$HOME/.notes;\
v:$HOME/.local/share/nvim;z:$HOME/.local/share/zinit/plugins;\
b:$HOME/build;p:$HOME/backed;A:$HOME/.tmp;\
a:$MY_NNN_TMP;t:$HOME/.local/share/Trash;\
"
export NNN_TRASH=1
export NNN_OPENER="${XDG_CONFIG_HOME}/nnn/plugins/nnn_my_opener"
export NNN_ARCHIVE="\\.(7z|bz2|gz|xz|lzo|rar|zst|lz4|lrz|tar|tgz|zip|xpi|jar)$"
# cd on quit
export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
