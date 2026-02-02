# Commit staged files and squash into previous commit (history rewrite)
function my-git-commit-and-squash-into-prev() {
	if ! git rev-parse --git-dir &>/dev/null; then
		>&2 echo "ERROR: Not a git repository"
		return 1
	fi

	if ! git diff --cached --quiet; then
		echo "Staged files:"
		git diff --name-only --cached
	else
		>&2 echo "ERROR: No staged changes to commit"
		return 1
	fi

	if ! git rev-parse --verify --quiet HEAD~1; then
		>&2 echo "ERROR: No previous commit to squash into"
		return 1
	fi

	echo "\nSquash staged changes into previous commit?"
	if ! read -q "?y/n: "; then
		echo "\nAborting..."
		return 1
	fi
	echo

	git commit --amend --no-edit || {
		>&2 echo "ERROR: Commit amend failed"
		return 1
	}
}

# Show commits difference between current branch and its upstream
function my-git-divergence-remote() {
	if ! git rev-parse --git-dir &>/dev/null; then
		>&2 echo "ERROR: Not a git repository"
		return 1
	fi

	local upstream
	upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null) || {
		echo "Current branch does not track any upstream."
		return 1
	}

	git fetch --quiet "${upstream%%/*}" || {
		>&2 echo "ERROR: Cannot fetch upstream"
		return 1
	}

	_my-print-heading-blue "\nCommits on remote not yet pulled:"
	git log --oneline "..$upstream"

	_my-print-heading-blue "\nCommits not yet pushed:"
	git log --oneline "$upstream.."
}