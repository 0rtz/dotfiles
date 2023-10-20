####################################################################################
### default utils
alias l='ls -lAFh --color=tty'
alias src='exec zsh'
alias lns='ln -s <link_to> <link_name>'
alias cp='cp -i'
alias mv='mv -i'
alias md='mkdir -p'
alias rmr='rm -rf'
alias k='kill'
alias K='kill -9'
alias trt='touch .root'
alias ddr='dd if=/dev/urandom bs=4K count=1 | base64 > output.dat'
alias dud='du -d 1 -ch --apparent-size | sort --human-numeric-sort'
alias duf='find . -type f -exec du -csh --apparent-size {} + | sort --human-numeric-sort'
alias psa='ps aux'
alias pscpu='ps -eo pid,ppid,cmd:50,%mem,%cpu --sort=-%cpu | head'
alias clrls='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+"\n"}; done'
alias s='TERM=xterm-256color ssh'
alias st='TERM=xterm-256color ssh -Y'
alias sshk='ssh-copy-id'
alias sshr='ssh-keygen -R'
alias kern='uname --kernel-release --machine'
alias kerncfg='zless /proc/config.gz'
alias fdpat='find . -name "*pat*"'
alias genstr="LC_ALL=C tr -dc 'A-Za-z0-9-_' </dev/urandom | head -c 12"
alias diffproc='diff <() <()'
alias networking_connections='lsof -Pni'
alias follow='tail -n 100 -F'
alias -g L='2>&1 | less -r'
alias -g T='2>&1 | tee .my.log'
alias -g NO='>/dev/null'
alias -g NE='2>/dev/null'
alias -g NULL='>/dev/null 2>&1'
alias -g H='--help 2>&1'
alias -g S='| tr " " "\n"'
alias -g C='| wc -l'
alias -g E='| tail'
alias -g B='| head'
alias -g G='| grep -e'
alias -g J='| jiq'
####################################################################################


####################################################################################
### my functions
alias e='my-eval-var'
alias m='my-man-fzf'
alias v='my-editor-open'
alias vt='my-create-edit-tmp'
alias vx='my-create-script'
alias pw='my-powermenu-fzf'
alias cpf='my-yank-to-clipboard'
alias rn='my-tmux-session-run-cmd ""'
alias psf='my-processes-fzf'
alias rnd='my-tmux-session-create-run-cmd ""'
alias rgf='my-ripgrep-fzf'
alias nf='my-notfiy-wrapper'
alias -g Y='| my-yank-to-clipboard'
alias -g F='| my-yank-fzf'
####################################################################################


####################################################################################
### external utils
alias c='cht.sh'
alias q='qalc'
alias cs='cht.sh --shell bash'
alias ea='direnv allow . && src'
alias eb='direnv block .'
alias vd='nvim -u $HOME/.config/nvim/init.vim-debug/init.vim'
alias qr='qrencode -m 2 -t UTF8 <<<'
alias ff='plocate --ignore-case'
alias rg='rg --hidden --no-ignore 2>/dev/null ""'
alias rga='rga --hidden --no-ignore 2>/dev/null ""'
alias emj="emoji-fzf preview --prepend | fzf | awk '{ print \$1 }' | my-yank-to-clipboard"
alias spl="codespell --write-changes"
alias nls="cat $HOME/.config/nnn/.selection | tr \"\0\" \"\n\""
alias scsht='grim -g "$(slurp)" - | wl-copy'
alias screc='wf-recorder --geometry "$(slurp)" -f ./recording.mp4'
alias networking_ports='sudo ss -lntup'
alias TA='task add'
alias TL='task list'
alias TD='task done'
alias TE='task <task_number> modify'
alias dut='gdu'
alias dua='gdu -n /'
if command -v exa > /dev/null; then
	alias l='exa -aglbh --git --icons --color always'
	alias ll='ls -lAFh --color=tty'
	alias tree='exa -glbh --git --icons -T -I ".git" --git-ignore -a --color always | less -r'
fi
if command -v duf > /dev/null; then
	alias df='\duf'
fi
if command -v bat > /dev/null; then
	alias cat='bat --theme="ansi"'
	alias catp='bat --theme="ansi" --paging=never'
	alias ccat='\cat'
fi
if command -v batman > /dev/null; then
	alias m='batman'
else
fi
####################################################################################

####################################################################################
### systemd
alias scenable='sudo systemctl enable --now'
alias scdisable='sudo systemctl disable'
alias scstatus='systemctl status'
alias sclist='systemctl list-unit-files'
alias sctimers='systemctl list-timers --all'
alias scshow='systemctl show'
alias scfail='systemctl --failed'
alias sclogs='journalctl -u'
alias scstart='sudo systemctl start'
alias scstop='sudo systemctl stop'
alias screload='sudo systemctl reload'
alias screloadall='sudo systemctl daemon-reload'
alias screstart='sudo systemctl restart'
alias scedit='sudo EDITOR=vim systemctl edit'
alias scuenable='systemctl --user enable --now'
alias scudisable='systemctl --user disable'
alias scustatus='systemctl status --user'
alias sculist='systemctl --user list-unit-files'
alias scutimers='systemctl --user list-timers --all'
alias scushow='systemctl --user show'
alias scufail='systemctl --user --failed'
alias sculogs='journalctl --user-unit='
alias scustart='systemctl --user start'
alias scustop='systemctl --user stop'
alias scureload='systemctl --user reload'
alias scureloadall='systemctl --user daemon-reload'
alias scurestart='systemctl --user restart'
alias scuedit='systemctl --user edit'
####################################################################################


####################################################################################
### python
alias p='python3'
alias pv='my-create-pyton-env'
alias pin='pipx install'
alias pls='pipx list'
alias prm='pipx uninstall'
alias pipin='pip install'
alias piprm='pip uninstall'
alias pipls='pip list'
####################################################################################


####################################################################################
### npm
alias npmin='npm install'
alias npmrm='npm uninstall'
alias npming='npm install -g'
alias npmrmg='npm uninstall -g'
####################################################################################


####################################################################################
### git
alias gst='git status'
# clone
alias gcl='git clone'
alias gcls='git clone --recurse-submodules --jobs $(nproc)'
# add/stage
alias ga='forgit::add'
alias gaa='git add --all'
alias gunadd='forgit::reset::head'
## only add already tracked modified files
alias gat='git add -u'
alias gac='git add --all && git commit -v; git config user.name; git config user.email'
alias gacp='git add --all && git commit -v; git config user.name; git config user.email; git push'
alias gasq='git add --all && my-git-commit-and-squash-into-prev'
# diff
alias gd='forgit::diff'
alias gds='forgit::diff --staged'
alias gdh='forgit::diff HEAD~1 HEAD'
# stash changes
alias gstp='git stash push'
alias gsta='git stash pop'
alias gstls='git stash list'
alias gstf='forgit::stash::show'
alias gstrm='git stash drop'
# commit
alias gc='git commit -v && git config user.name && git config user.email'
alias gcm='git commit -m ""'
alias gacm='git add --all && git commit -m ""'
alias gcca='git commit -v --amend --no-edit --author="$(git config user.name) <$(git config user.email)>"'
alias gccm='git commit -v --amend'
alias gsq='my-git-commit-and-squash-into-prev'
## checkout
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='forgit::checkout::branch'
alias gctf='forgit::checkout::tag'
alias gccf='forgit::checkout::commit'
## branches
alias gba='my-git-create-branch-remote'
alias gbls='git branch -a -vv'
alias gbrm='forgit::branch::delete'
alias gbrmr='my-git-delete-branch-remote'
alias gbrn='git branch -m <new_branch_name>'
alias gbmv='git branch --force <branch_to_move_on_current>'
alias gbmvcp='my-git-move-on-current-cherrypick-last'
## patches
alias gap='git apply'
alias gam='git am'
alias gamc='git am --continue'
alias gama='git am --abort'
alias gams='git am --skip'
## history
alias glg='forgit::log'
alias gla='git log --graph --decorate --format=full'
alias glol='git log --graph --decorate --pretty=oneline --abbrev-commit'
alias gblm='forgit::blame'
## cherry-pick
alias gcp='forgit::cherry::pick <branch_to_pick_from>'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
## rebase
alias grb='git rebase <branch_to_rebase_onto>'
alias grbi='forgit::rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
## merge
alias gm='git merge'
alias gma='git merge --abort'
## submodules
alias gsub='git submodule init; git submodule update'
alias gsu='git submodule update'
alias gsa='git submodule add -b <branch_to_track_if_any> <url>'
alias gsrm='git rm <path-to-submodule>'
## search repo
alias glgr='my-git-log-grep-commit-messages <pattern>'
alias ggr='my-git-grep <pattern>'
## repository config
alias gcfg="my-git-edit-config \"$(git config user.name)\" \"$(git config user.email)\""
alias gi='forgit::ignore >> .gitignore'
alias gignore='git update-index --assume-unchanged'
alias gunignore='git update-index --no-assume-unchanged'
alias gkeep='echo >> .gitkeep'
## git objects
alias glls='my-git-list-large'
alias glrm='git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch <path_to_file>" HEAD'
alias gso='git show'
alias gtls='git tag | sort -V'
## revert changes
alias gunmodify='git checkout --'
alias grh='git reset --hard'
alias gclean='forgit::clean'
alias grv='forgit::revert::commit'
## remote
alias grup='git remote update'
alias grls='git remote -v'
alias grrm='git remote remove'
alias gra='my-add-git-remote <name> <link>'
alias gf='git fetch'
alias gprune='git fetch origin --prune'
## push
alias gp='git push'
alias gpf='git push --force-with-lease'
# push and create branch on origin
alias gpu='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
## pull
alias gl='git pull'
alias glr='git pull --rebase'
####################################################################################


####################################################################################
### tmux
alias ts='tmux new-session -s'
alias ta='tmux attach-session -t'
alias tk='tmux kill-session -t'
alias tK='tmux kill-server'
alias tks='tmux kill-session'
alias tl='tmux list-sessions'
alias tx='tmuxinator start'
alias t='tmuxinator simple'
alias txls='tmuxinator list'
alias txa='tmuxinator new'
alias txe='tmuxinator edit'
alias txrm='tmuxinator delete'
####################################################################################


####################################################################################
### arch linux
if command -v pacman > /dev/null; then
	alias pacup='sudo pacman -Syu'
	alias pacin="pacman -Slq | fzf --multi --preview-window=wrap --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk \"{print \$2}\")' | xargs -ro sudo pacman -S"
	alias pacinstall="sudo pacman -S"
	alias pacrm="sudo pacman -Rns"
	alias pacse="pacman -F"
	alias pacown="pacman -Qo"
	alias pacls="my-packages-list"
	alias paclsa="pacman -Q"
	alias pacdeps="pactree"
	alias pacdepsr="pactree -r"
	alias yain="yay --aur -Sl | fzf --multi --preview-window=wrap --preview 'cat <(yay -Si {2})' | cut -d' ' -f2 | xargs -ro yay -S"
	alias yainstall="yay -S"
fi
####################################################################################
