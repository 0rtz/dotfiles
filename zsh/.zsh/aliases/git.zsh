alias gst='git status'
# clone
alias gcl='git clone --recurse-submodules --jobs $(nproc)'
alias gcls='git clone --depth 1'
# add/stage
alias ga='forgit::add'
alias gaa='git add --all'
alias gunadd='forgit::reset::head'
### only add already tracked modified files
alias gat='git add -u'
###
alias gac='git add --all && git commit -v; git config user.name; git config user.email'
alias gacp='git add --all && git commit -v; git config user.name; git config user.email; git push'
alias gasq='git add --all && my-git-commit-and-squash-into-prev'
# diff
alias gd='forgit::diff'
alias gds='forgit::diff --staged'
alias gdl='forgit::diff HEAD~1 HEAD'
alias gdm='my-git-main-branch-diff'
alias gdr='my-git-divergence-remote'
# stash changes
alias gstp='forgit::stash::push'
alias gsta='git stash pop'
alias gstls='git stash list'
alias gstf='forgit::stash::show'
alias gstrm='git stash drop'
# commit
alias gc='git commit -v && git config user.name && git config user.email'
alias gcm='git commit -m ""'
alias gacm='git add --all && git commit -m ""'
alias gcca='git commit -v --amend --no-edit --author="$(git config user.name) <$(git config user.email)>"'
alias gccmsg='git commit -v --amend'
alias gsq='my-git-commit-and-squash-into-prev'
# checkout
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='forgit::checkout::branch'
alias gctf='forgit::checkout::tag'
alias gccf='forgit::checkout::commit'
# branches
alias gba='my-git-create-branch-remote <branch> (<remote>)'
alias gbls="git branch --sort=committerdate --format '%(HEAD) %(color:yellow)%(refname:short)%(color:reset) -> %(color:cyan)%(upstream:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) => \"%(contents:subject)\" (%(color:green)%(committerdate:relative)%(color:reset))'"
alias gblsr="git branch --remotes --sort=committerdate --format '%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) => \"%(contents:subject)\" (%(color:green)%(committerdate:relative)%(color:reset))'"
alias gbrm='forgit::branch::delete'
alias gbrmr='my-git-delete-branch-remote'
alias gbrn='git branch -m <new_branch_name>'
alias gbmv='git branch --force <branch_to_move> [<commit>]'
alias gbmvcp='my-git-move-on-current-cherrypick-last <branch>'
# patches
alias gap='git apply'
alias gam='git am'
alias gamc='git am --continue'
alias gama='git am --abort'
alias gams='git am --skip'
# history
alias glg='forgit::log'
alias glgfull='git log --graph --decorate --format=full --pretty=fuller'
alias glgol='git-foresta --style=15 2>&1 | less --use-color -r'
alias glgb='git log --graph --decorate --pretty=oneline --abbrev-commit --all'
alias glgfunc='git log -L:"<function_name>:<filename>"'
alias gblm='forgit::blame'
# cherry-pick
alias gcp='forgit::cherry::pick <branch_to_pick_from>'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
# rebase
alias grb='git rebase <branch_to_rebase_onto>'
alias grbi='forgit::rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
# merge
alias gm='git merge'
alias gma='git merge --abort'
# submodules
alias gsub='git submodule init; git submodule update'
alias gsu='git submodule update --checkout --init --jobs "$(nproc)" --depth 1'
alias gsa='git submodule add -b <branch_to_track_if_any> <url>'
alias gsrm='git rm <path-to-submodule>'
# search repo
alias glgr='my-git-log-grep-commit-messages <pattern>'
alias ggr='my-git-grep <pattern>'
# repository config
alias gcfg="my-git-edit-config \"$(git config user.name)\" \"$(git config user.email)\""
alias gia='forgit::ignore >> .gitignore'
alias gignore='git update-index --assume-unchanged'
alias gunignore='git update-index --no-assume-unchanged'
alias gkeep='echo >> .gitkeep'
# git objects info
alias gso='git show'
alias gtls='git tag | sort -V'
alias gils='git ls-files --others --i --exclude-standard'
# revert changes
alias gunmodify='git checkout --'
alias grh='git reset --hard'
alias gclean='forgit::clean'
alias gundo='git reflog'
### works with reflog
alias grv='git revert'
###
alias grvc='forgit::revert::commit'
# remote
alias grup='git remote update'
alias grls='git remote -v'
alias grrm='git remote remove'
alias gra='my-add-git-remote <name> <link>'
# push
alias gp='git push'
alias gpf='git push --force-with-lease'
### push and create branch on 'origin'
alias gpu='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
###
# pull
alias gl='git pull'
alias glr='git pull --rebase'
alias gla='my-git-checkout-all-branches'
alias gf='git fetch'
alias gprune='git fetch origin --prune'
