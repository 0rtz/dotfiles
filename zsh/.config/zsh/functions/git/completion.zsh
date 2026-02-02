# Git zsh completion helpers for my custom functions

# Complete local branch names
_JJD-git-branch-names() {
	compadd "${(@)${(f)$(git branch)}#??}"
}

# Complete remote branch names (origin/main, etc.)
_JJD-git-remote-branch-names() {
	compadd "${(@)${(f)$(git branch --remotes)}#??}"
}

# Complete remote names (origin, upstream, etc.)
_JJD-git-remote-names() {
	compadd "${(@)${(f)$(git remote)}}"
}
