alias q='qalc'

alias fm='nautilus $PWD >/dev/null 2>&1 &!'
alias mt='my_time.sh -t 10'
alias ea='direnv allow . && src'
alias eb='direnv block .'
alias qr='qrencode -m 2 -t UTF8 <<<'
alias hx='hexdump -C'

alias vim='nvim -u /dev/null'
alias emj="emoji-fzf preview --prepend | fzf | awk '{ print \$1 }' | my-yank-to-clipboard"
alias curl='curl --tlsv1.3 --location --proto https'

# Disk Usage Tui
alias dut='gdu'
# Disk Usage All
alias dua='gdu -n /'

alias ff='plocate --ignore-case'
alias ffu='sudo updatedb'

alias rg='rg --hidden --no-ignore 2>/dev/null ""'
alias rga='rga --hidden --no-ignore 2>/dev/null ""'
alias rgaf='my-ripgrep-all-fzf'

# Taskwarrior
alias wa='task add project:'
alias wls='task next project:'
alias wrm='task done project:'
alias we='task $TASK_NUMBER modify project:'
alias wpls='task projects'

if (( ${+commands[eza]} )); then
	alias l='eza -aglbh --git --icons --color always'
	alias ll='ls -lAFh --color=tty'
	alias tree='eza -glbh --git --icons -T -I ".git" --git-ignore -a --color always | less -r'
fi

if (( ${+commands[duf]} )); then
	alias df='\duf'
fi

if (( ${+commands[bat]} )); then
	alias cat='bat --theme="ansi"'
fi

if (( ${+commands[batman]} )); then
	alias m='batman'
fi

if (( ${+commands[jiq]} )); then
	alias -g J='| jiq -q'
fi

if (( ${+commands[fzf]} )); then
	alias -g F='| fzf'
fi