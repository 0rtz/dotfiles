# nnn file manager https://github.com/jarun/nnn

export NNN_INCLUDE_HIDDEN=1

# nnn plugins
NNN_PLUG_BUNDLED='f:fzcd;p:preview-tui;r:gitroot;n:fixname;D:diffs'
NNN_PLUG_CMDS='s:-!sudoedit "$nnn"*;g:-!neovide "$nnn" >/dev/null 2>&1 & disown*'
NNN_PLUG_YANK='y:-nnn_file_path_yank;Y:-nnn_file_name_yank;d:-nnn_file_dir_yank'
NNN_PLUG_CD='c:nnn_clipboard_file_path_cd'
export NNN_PLUG="$NNN_PLUG_BUNDLED;$NNN_PLUG_CMDS;$NNN_PLUG_YANK;$NNN_PLUG_CD;"

# Filesystem bookmarks
export NNN_BMS="\
d:$HOME/.dotfiles;c:$HOME/.config;n:$HOME/.notes;\
v:$HOME/.local/share/nvim;z:$HOME/.local/share/zinit/plugins;\
b:$HOME/build;p:$HOME/backed;A:$HOME/.tmp;\
a:/tmp;t:$HOME/.local/share/Trash;\
"

# nnn options
export NNN_TRASH=1
export NNN_OPENER="${XDG_CONFIG_HOME}/nnn/plugins/nnn_my_opener"
export NNN_ARCHIVE="\\.(7z|bz2|gz|xz|lzo|rar|zst|lz4|lrz|tar|tgz|zip|xpi|jar)$"
# cd on quit
export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
