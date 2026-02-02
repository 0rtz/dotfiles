# Create branch locally and push to remote, or checkout if exists
function my-git-create-branch-remote() {
	if [[ $1 == -h || $1 == --help ]]; then
		echo "Usage: my-git-create-branch-remote <branch> [remote=origin]"
		return 0
	fi

	local branch="$1"
	local remote="${2:-origin}"

	if [[ -z "$branch" ]]; then
		>&2 echo "ERROR: Specify branch name"
		return 1
	fi

	echo "Create or checkout branch '$branch' on remote '$remote'?"
	if ! read -q "?y/n: "; then
		echo "\nAborting..."
		return 1
	fi
	echo

	if git ls-remote --heads "$remote" "$branch" | grep -q .; then
		echo "Branch '$branch' exists on $remote"

		git show-ref --verify --quiet "refs/remotes/$remote/$branch" \
			|| git fetch "$remote" "$branch"

		git checkout "$branch" 2>/dev/null \
			|| git checkout -t "$remote/$branch"
	else
		git checkout -b "$branch" || return 1
		git push -u "$remote" "$branch"
	fi
}
compdef _JJD-git-remote-names my-git-create-branch-remote

# Delete branch locally and on remote
function my-git-delete-branch-remote() {
	if [[ $1 == -h || $1 == --help ]]; then
		echo "Usage: my-git-delete-branch-remote <branch> [remote=origin]"
		return 0
	fi

	local branch="$1"
	local remote="${2:-origin}"

	if [[ -z "$branch" ]]; then
		>&2 echo "ERROR: Specify branch name"
		return 1
	fi

	if [[ "$branch" == "$(git rev-parse --abbrev-ref HEAD)" ]]; then
		>&2 echo "ERROR: Cannot delete the current branch"
		return 1
	fi

	local is_local=0
	git show-ref --verify --quiet "refs/heads/$branch" && is_local=1

	local is_remote=0
	if git ls-remote --heads "$remote" "$branch" | grep -q .; then
		is_remote=1

		local default_branch
		default_branch=$(git remote show "$remote" 2>/dev/null |
			grep 'HEAD branch' | cut -d':' -f2 | tr -d '[:blank:]')

		if [[ "$branch" == "$default_branch" ]]; then
			>&2 echo "ERROR: Cannot delete '$branch' — default branch on $remote"
			>&2 echo "Change the default branch first, then try again"
			return 1
		fi
	fi

	if (( ! is_local && ! is_remote )); then
		>&2 echo "ERROR: Branch '$branch' does not exist locally or on $remote"
		return 1
	fi

	echo -n "Delete branch '$branch'"
	(( is_local )) && echo -n " locally"
	(( is_local && is_remote )) && echo -n " and"
	(( is_remote )) && echo -n " on remote '$remote'"
	echo "?"

	if ! read -q "?y/n: "; then
		echo "\nAborting..."
		return 1
	fi
	echo

	if (( is_local )); then
		git branch -D "$branch" || {
			>&2 echo "ERROR: Cannot delete '$branch' locally"
			return 1
		}
	fi

	if (( is_remote )); then
		git push --delete "$remote" "$branch" || {
			>&2 echo "ERROR: Cannot delete '$branch' on $remote"
			return 1
		}
	fi

	echo "Deleted."
}
_my-git-delete-branch-remote() {
	_arguments '1:branch:->branches' '2:remote:->remotes'
	case $state in
		branches) _JJD-git-branch-names ;;
		remotes) _JJD-git-remote-names ;;
	esac
}
compdef _my-git-delete-branch-remote my-git-delete-branch-remote

# Rename branch locally and (if published) on remote
function my-git-rename-branch-remote() {
	if [[ -z "$1" || -z "$2" ]]; then
		echo "Usage: my-git-rename-branch-remote <old> <new> [remote=origin]"
		return 1
	fi

	local old="$1"
	local new="$2"
	local remote="${3:-origin}"

	# Determine upstream (if any)
	local upstream
	upstream=$(git rev-parse --abbrev-ref --symbolic-full-name "$old@{u}" 2>/dev/null)

	# Rename locally
	git branch -m "$old" "$new" || return 1

	# If branch was never pushed, stop here
	if [[ -z "$upstream" ]]; then
		echo "Renamed local branch '$old' → '$new' (no remote branch)"
		return 0
	fi

	# Extract remote and remote branch name
	local upstream_remote="${upstream%%/*}"
	local upstream_branch="${upstream#*/}"

	# Rename remote branch
	git push "$upstream_remote" ":$upstream_branch" "$new" || return 1
	git push -u "$upstream_remote" "$new"

	echo "Renamed branch locally and on '$upstream_remote'"
}
compdef _JJD-git-branch-names my-git-rename-branch-remote

# Set current branch to track a remote branch
function my-git-track-remote-branch() {
	if [[ $1 == -h || $1 == --help || -z "$1" ]]; then
		echo "Usage: my-git-track-remote-branch <remote/branch>"
		return 0
	fi

	if ! git show-ref --verify --quiet "refs/remotes/$1"; then
		>&2 echo "ERROR: Remote branch '$1' does not exist"
		return 1
	fi

	git branch --set-upstream-to="$1"
}
compdef _JJD-git-remote-branch-names my-git-track-remote-branch

# Move branch and its last commit (cherry-pick) to current HEAD
function my-git-move-on-current-cherrypick-last() {
	if [[ $1 == -h || $1 == --help || -z "$1" ]]; then
		echo "Usage: my-git-move-on-current-cherrypick-last <branch>"
		return 0
	fi

	if ! git show-ref --verify --quiet "refs/heads/$1"; then
		>&2 echo "ERROR: Branch '$1' does not exist"
		return 1
	fi

	local commit
	commit=$(git rev-parse "$1") || return 1

	# Cherry-pick onto current HEAD
	git cherry-pick "$commit" || {
		>&2 echo "ERROR: Cherry-pick failed"
		return 1
	}

	# Move branch to new HEAD
	git branch -f "$1" HEAD || {
		>&2 echo "ERROR: Cannot move branch"
		return 1
	}
}
compdef _JJD-git-branch-names my-git-move-on-current-cherrypick-last

# Show diff between base branch (e.g. main) and current commit
# i.e. If I opened a PR right now, what would the diff be?
function my-git-main-branch-diff() {
	if [[ $1 == -h || $1 == --help ]]; then
		echo "Usage: my-git-main-branch-diff [base_branch]"
		return 0
	fi

	local base
	if [[ -n "$1" ]]; then
		base="$1"
	else
		base=$(git symbolic-ref --quiet refs/remotes/origin/HEAD |
			sed 's@^refs/remotes/origin/@@')
	fi

	if [[ -z "$base" ]]; then
		>&2 echo "ERROR: Could not determine default branch"
		return 1
	fi

	git rev-parse --verify --quiet "$base" || {
		>&2 echo "ERROR: Base branch '$base' does not exist"
		return 1
	}

	local mb
	mb=$(git merge-base HEAD "$base") || return 1

	git diff "$mb..HEAD"
}
compdef _JJD-git-branch-names my-git-main-branch-diff

# Create local tracking branches for all remote branches
function my-git-checkout-all-branches() {
	if ! git rev-parse --git-dir &>/dev/null; then
		>&2 echo "ERROR: Not a git repository"
		return 1
	fi

	local current
	current=$(git symbolic-ref --quiet --short HEAD || true)

	echo "Creating local tracking branches for remote branches..."

	git for-each-ref --format='%(refname:short)' refs/remotes | while read -r remote_branch; do
		[[ "$remote_branch" == */HEAD ]] && continue

		local remote="${remote_branch%%/*}"
		local branch="${remote_branch#*/}"

		# Skip if local branch already exists
		git show-ref --verify --quiet "refs/heads/$branch" && continue

		echo "  + $branch -> $remote_branch"
		git branch --track "$branch" "$remote_branch"
	done

	# Restore original branch if possible
	if [[ -n "$current" ]]; then
		git checkout "$current"
	fi
}

# Delete local branches merged into base branch
function my-git-prune-merged-branches() {
	local base="${1:-$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@')}"

	echo "Deleting branches merged into '$base'..."

	git branch --merged "$base" |
		grep -vE "^\*|$base$" |
		while read -r b; do
			echo "  - $b"
			git branch -d "$b"
		done
}
compdef _JJD-git-branch-names my-git-prune-merged-branches

function my-git-list-branches() {
	echo "Local branches:"
	git branch --sort=committerdate --format '%(HEAD) %(color:yellow)%(refname:short)%(color:reset) -> %(color:cyan)%(upstream:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) => "%(contents:subject)" (%(color:green)%(committerdate:relative)%(color:reset))'
	echo ""
	echo "Remote branches:"
	git branch --remotes --sort=committerdate --format '%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) => "%(contents:subject)" (%(color:green)%(committerdate:relative)%(color:reset))'
}