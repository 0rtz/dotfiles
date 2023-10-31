function my-add-git-remote() {
	git remote add $1 $2
	git fetch $1
}

# $1 = Branch name to create on remote (Required parameter)
# $2 = Remote name to create branch on (Optional parameter)
function my-git-create-branch-remote() {
	if [[ -z $1 ]]; then
		>&2 echo -e "\nERROR. Specify branch to create. Exiting..."
		return 1
	fi
	local branch_name="$1"
	if [[ -n $2 ]]; then
		local remote_name="$2"
	else
		local remote_name="origin"
	fi
		print "Create branch $branch_name on remote: \'$remote_name\'"
		if read -q "choice?y/n?: "; then
			if [[ $(git ls-remote --heads $(git config --get remote."$remote_name".url) $branch_name | wc -l) -ge 1 ]]; then
				echo "Branch $branch_name already exist on $remote_name";
				if ! git rev-parse --verify "$remote_name/$branch_name" > /dev/null 2>&1; then
					echo "Fetching $remote_name...";
					git fetch "$remote_name"
				fi
				git checkout -t "$remote_name/$branch_name"
			else
				git checkout -b $branch_name || return 1
				git push -u $remote_name $branch_name
			fi
		else
			print "\nAborting..."
		fi
}

# $1 = Branch name to delete on remote (Required parameter)
# $2 = Remote name to delete branch on (Optional parameter)
function my-git-delete-branch-remote() {
	if [[ -z $1 ]]; then
		>&2 echo -e "\nERROR. Specify branch to delete. Exiting..."
		return 1
	fi
	local branch_name="$1"
	if [[ -n $2 ]]; then
		local remote_name="$2"
	else
		local remote_name="origin"
	fi
	local branch_count=$(git ls-remote --heads $(git config --get remote."$remote_name".url) $branch_name | wc -l)
	if [[ $branch_count -ne 1 ]]; then
		if [[ $branch_count -gt 1 ]]; then
			>&2 echo -e "Multiple branches with name $branch_name exist on $remote_name."
			return 1
		else
			>&2 echo -e "Branch $branch_name does not exist on $remote_name."
			return 1
		fi
	else
		print -n "Delete branch: \'$branch_name\'"
		$(git rev-parse --verify $branch_name > /dev/null 2>&1 )
		local is_local=$?
		if [[ $is_local -eq 0 ]]
		then
			print -n " locally and"
		fi
		print " on remote: \'$remote_name\'"
		if read -q "choice?y/n?: "; then
			echo
			if [[ $is_local -eq 0 ]]
			then
				git branch --delete $branch_name || \
					{ >&2 echo -e "\nERROR: Can not delete branch $branch_name locally. Exiting..."; return 1 }
			fi
			git push --delete $remote_name $branch_name || \
				{ >&2 echo -e "\nERROR: Can not delete branch $branch_name on remote $remote_name. Exiting..."; return 1 }
			print "\nDeleted."
		else
			print "\nAborting..."
		fi
	fi
}
_JJD-git-branch-names() {
	compadd "${(@)${(f)$(git branch)}#??}"
}
compdef _JJD-git-branch-names my-git-delete-branch-remote

function my-git-log-grep-commit-messages() {
	git log --all --grep="$1"
}

function my-git-grep() {
	git grep "$1" $(git rev-list --all)
}

function my-git-commit-and-squash-into-prev() {
	echo -e "Commit staged files:\n$(git diff --name-only --cached)\n\nAnd rebase commit onto previous one?"
	if read -q "choice?y/n?: "; then
		echo
		git commit -m "squash this commit into previous one" || \
		{ >&2 echo -e "\nERROR. Fix before continuing squashing. Exiting..."; return 1 }
		git reset --soft HEAD~2
		git commit --reedit-message=HEAD@{2}
	else
		print "\nAborting..."
	fi
}

function my-git-edit-config() {
	git config user.name "$1";
	git config user.email "$2";
	echo "New git repo name: "; git config user.name
	echo "New git repo email: "; git config user.email
}

# move branch to current HEAD and cherry pick it's last commit from previous position
function my-git-move-on-current-cherrypick-last() {
	if  ! git rev-parse --quiet --verify "$1" > /dev/null; then
		>&2 echo -e "\nERROR. Branch: $1 does not exist. Exiting...\n"; return 1
	fi
	CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
	CHERRY_PICK_COMMIT=$(git rev-parse "$1")
	git branch --force "$1" || \
		{ >&2 echo -e "\nERROR. Can not move branch $1 on current commit. Exiting..."; return 1 }
	git checkout "$1" || \
		{ >&2 echo -e "\nERROR. Can not checkout branch $1. Exiting..."; return 1 }
	git cherry-pick "$CHERRY_PICK_COMMIT" || \
		{ >&2 echo -e "\nERROR. Can not cherry pick $CHERRY_PICK_COMMIT commit. Exiting..."; return 1 }
}
compdef _JJD-git-branch-names my-git-move-on-current-cherrypick-last

function my-git-list-large() {
	git rev-list --objects --all |
	git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
	sed -n 's/^blob //p' |
	sort --numeric-sort --key=2 |
	cut -c 1-12,41- |
	$(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
}
