### Clone ###
alias gcl='git clone --recurse-submodules --jobs $(nproc)'
alias gcls='git clone --depth 1'

### Add/Stage ###
alias ga='forgit::add'
alias gaa='git add --all'
alias guna='forgit::reset::head'
# Only add already tracked modified files
alias gat='git add -u'

### Diff ###
alias gd='forgit::diff'
alias gds='forgit::diff --staged'
alias gdh='forgit::diff HEAD~1 HEAD'
alias gbd='my-git-main-branch-diff'

### Commit ###
alias gc='git commit -v && git config user.name && git config user.email'
alias gcm='git commit -m ""'
alias gac='git add --all && git commit -v; git config user.name; git config user.email'
alias gacp='git add --all && git commit -v; git config user.name; git config user.email; git push'
alias gacm='git add --all && git commit -m ""'
alias gcca='git commit -v --amend --no-edit --author="$(git config user.name) <$(git config user.email)>"'
alias gccmsg='git commit -v --amend'
alias gcrice="git add --all && git commit -m 'ricing...'"
alias gsq='my-git-commit-and-squash-into-prev'
alias gasq='git add --all && my-git-commit-and-squash-into-prev'
alias gcoc='forgit::checkout::commit'

### Push ###
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpu='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)' # set branches remote to 'origin' and push branch

### Pull ###
alias gl='git pull'
alias glr='git pull --rebase'
alias gf='git fetch'
alias gprune='git fetch origin --prune'

### Branches ###
alias gb='forgit::checkout::branch'
alias gba='my-git-create-branch-remote'
alias gbls="my-git-list-branches"
alias gbrm='my-git-delete-branch-remote'
alias gbrn='my-git-rename-branch-remote'
alias gbmv='git branch --force $BRANCH'
alias gbmvcp='my-git-move-on-current-cherrypick-last'
alias gla='my-git-checkout-all-branches'

### Remote ###
alias gra='my-add-git-remote'
alias grup='git remote update'
alias grls='git remote -v'
alias grrm='git remote remove'

### History ###
alias glg='forgit::log'
alias glgfull='git log --graph --decorate --format=full --pretty=fuller'
alias glgol='my_git_log_pretty --style=15 2>&1 | less --use-color -r'
alias glgb='git log --graph --decorate --pretty=oneline --abbrev-commit --all'
alias gblm='forgit::blame'

### Cherry-pick ###
alias gcp='forgit::cherry::pick $BRANCH'
alias gcpc='git cherry-pick --continue'
alias gcpa='git cherry-pick --abort'

### Rebase ###
alias grb='forgit::rebase'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'

### Merge ###
alias gm='git merge'
alias gma='git merge --abort'

### Submodules ###
alias gsub='git submodule init; git submodule update'
alias gsu='git submodule update --checkout --init --jobs "$(nproc)" --depth 1'
alias gsa='git submodule add -b $BRANCH $URL'
alias gsrm='git rm $SUBMODULE_PATH'

### Revert ###
alias gunmodify='git checkout --'
alias grh='git reset --hard'
alias gclean='forgit::clean'
alias gundo='git reflog'
alias grv='git revert' # works with reflog
alias grvc='forgit::revert::commit'

### Tags ###
alias gtls='git tag | sort -V'
alias gcot='forgit::checkout::tag'

### Ignore ###
alias gia='forgit::ignore >> .gitignore'
alias gignore='git update-index --assume-unchanged'
alias gunignore='git update-index --no-assume-unchanged'
alias gkeep='echo >> .gitkeep'
alias gignorels='git ls-files --others --i --exclude-standard' # list ignored files

### Stash ###
alias gsta='forgit::stash::push'
alias gstf='forgit::stash::show'
alias gstA='git stash pop'
alias gstls='git stash list'
alias gstrm='git stash drop'

### Misc ###

alias gst='git status'
# Show email/name
alias gcfg="my-git-repo-config"
# Search repo
alias ggrep='git grep "$PATTERN" $(git rev-list --all)'
# Show Git object info
alias gso='git show'