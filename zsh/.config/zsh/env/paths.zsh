# $PATH
typeset -U path

path+=($HOME/bin $HOME/usr/bin)
path+=($HOME/.local/bin $HOME/.cargo/bin $HOME/go/bin $HOME/npm/bin)

[[ -d $HOME/.local/share/gem/ruby ]] && path+=($HOME/.local/share/gem/ruby/*/bin(N[-1]))
[[ -d $HOME/.luarocks/bin ]] && path+=($HOME/.luarocks/bin)

export PATH

# $FPATH (custom completions), used by zinit
typeset -U fpath
export FPATH