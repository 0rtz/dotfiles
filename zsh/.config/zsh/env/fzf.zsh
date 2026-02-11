# fzf fuzzy finder https://github.com/junegunn/fzf

export FZF_DEFAULT_OPTS="-m \
--bind ctrl-d:preview-page-down,\
ctrl-u:preview-page-up,\
ctrl-s:jump,\
ctrl-space:toggle,\
ctrl-a:toggle-all,\
'ctrl-v:transform-query:echo -n {q}; if [ \"\$XDG_SESSION_TYPE\" = \"wayland\" ]; then wl-paste; else xclip -o -selection clipboard; fi'"

export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git"'

# Delta (child process) requires access to COLUMNS environment variable when running inside forgit (fzf)
# https://github.com/wfxr/forgit/issues/121#issuecomment-1380022751
# COLUMNS = number of character columns in the terminal, set by zsh, updated when the terminal resizes, not exported by default
# Verify visibility to child processes: env | grep -E 'COLUMNS'
export COLUMNS