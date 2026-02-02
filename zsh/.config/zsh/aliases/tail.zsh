alias -g C='| wc -l'
alias -g G='| grep -i -e ""'
alias -g X='| xargs --no-run-if-empty --open-tty -I{}'
alias -g L='2>&1 | less --use-color -r'
# NOTE: tee does not preserve colors
alias -g T='2>&1 | tee .my.log'
alias -g NO='>/dev/null'
alias -g NE='2>/dev/null'
alias -g NULL='>/dev/null 2>&1'
alias -g H='--help 2>&1'
alias -g B=">/dev/null 2>&1 &!"
alias -g Y='| my-yank-to-clipboard'