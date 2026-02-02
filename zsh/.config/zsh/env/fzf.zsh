# fzf fuzzy finder https://github.com/junegunn/fzf

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