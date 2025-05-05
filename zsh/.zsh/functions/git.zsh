_JJD-git-branch-names() {
	compadd "${(@)${(f)$(git branch)}#??}"
}
_JJD-git-remote-branch-names() {
	compadd "${(@)${(f)$(git branch --remotes)}#??}"
}
_JJD-git-remote-names() {
	compadd "${(@)${(f)$(git remote)}}"
}

function my-add-git-remote() {
	usage="
Usage: $(basename "$0") remote_name url
	"
	while [[ $# -gt 0 ]]; do
		case $1 in
			-h|--help)
				echo "${usage}"
				return
			;;
			*)
				POSITIONAL_ARGS+=("$1") # save positional arg
				shift
			;;
		esac
	done
	# restore arguments
	set -- "${POSITIONAL_ARGS[@]}"
	git remote add $1 $2
	git fetch $1
}

function my-git-create-branch-remote() {
	usage="
Usage: $(basename "$0") branch_name [remote_name]

'branch_name' = branch name to create on remote (required parameter)
'remote_name' = remote name to create branch on (optional parameter; default = origin)
	"
	while [[ $# -gt 0 ]]; do
		case $1 in
			-h|--help)
				echo "${usage}"
				return
			;;
			*)
				POSITIONAL_ARGS+=("$1") # save positional arg
				shift
			;;
		esac
	done
	# restore arguments
	set -- "${POSITIONAL_ARGS[@]}"
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
compdef _JJD-git-remote-names my-git-create-branch-remote

function my-git-delete-branch-remote() {
	usage="
Usage: $(basename "$0") branch_name [remote_name]

'branch_name' = branch name to delete on remote (required parameter)
'remote_name' = remote name to delete branch on (optional parameter; default = origin)
	"
	while [[ $# -gt 0 ]]; do
		case $1 in
			-h|--help)
				echo "${usage}"
				return
			;;
			*)
				POSITIONAL_ARGS+=("$1") # save positional arg
				shift
			;;
		esac
	done
	# restore arguments
	set -- "${POSITIONAL_ARGS[@]}"
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
_my-git-delete-branch-remote() {
	_arguments '1:branch:->branches' '2:remote:->remotes'
	case $state in
		branches)
			_JJD-git-branch-names
			;;
		remotes)
			_JJD-git-remote-names
			;;
	esac
}
compdef _my-git-delete-branch-remote my-git-delete-branch-remote

function my-git-track-remote-branch() {
	usage="
Usage: $(basename "$0") branch_name
Make current branch track remote branch 'branch_name' (required parameter)
	"
	while [[ $# -gt 0 ]]; do
		case $1 in
			-h|--help)
				echo "${usage}"
				return
			;;
			*)
				POSITIONAL_ARGS+=("$1") # save positional arg
				shift
			;;
		esac
	done
	# restore arguments
	set -- "${POSITIONAL_ARGS[@]}"

	branch=$(git rev-parse --abbrev-ref HEAD)
	git branch "$branch" --set-upstream-to "$1"
}
compdef _JJD-git-remote-branch-names my-git-track-remote-branch

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
	usage="
Usage: $(basename "$0") name email
Set name and email for current repo
	"
	while [[ $# -gt 0 ]]; do
		case $1 in
			-h|--help)
				echo "${usage}"
				return
			;;
			*)
				POSITIONAL_ARGS+=("$1") # save positional arg
				shift
			;;
		esac
	done
	# restore arguments
	set -- "${POSITIONAL_ARGS[@]}"
	git config user.name "$1";
	git config user.email "$2";
	echo "New git repo name: "; git config user.name
	echo "New git repo email: "; git config user.email
}

function my-git-move-on-current-cherrypick-last() {
	usage="
Usage: $(basename "$0") branch_name

branch_name = branch to move to current HEAD and cherry pick it's last commit from previous position (required parameter)
	"
	while [[ $# -gt 0 ]]; do
		case $1 in
			-h|--help)
				echo "${usage}"
				return
			;;
			*)
				POSITIONAL_ARGS+=("$1") # save positional arg
				shift
			;;
		esac
	done
	# restore arguments
	set -- "${POSITIONAL_ARGS[@]}"
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

function my-git-oldest-common-ancestor() {
	usage="
Usage: $(basename "$0") first_branch second_branch
Show oldest common ancestor between 'first_branch' and 'second_branch'
	"
	while [[ $# -gt 0 ]]; do
		case $1 in
			-h|--help)
				echo "${usage}"
				return
			;;
			*)
				POSITIONAL_ARGS+=("$1") # save positional arg
				shift
			;;
		esac
	done
	# restore arguments
	set -- "${POSITIONAL_ARGS[@]}"
	local b1=$1
	if [[ $# -eq 1 ]]; then
		local b2=HEAD
	else
		local b2=$2
	fi
	ancestor=$(diff --old-line-format='' --new-line-format='' \
		<(git rev-list --first-parent "$b1") \
		<(git rev-list --first-parent "$b2") | \
		head -1)
	git rev-parse --short "$ancestor"
}
compdef _JJD-git-branch-names my-git-oldest-common-ancestor

function my-git-recent-common-ancestor() {
	usage="
Usage: $(basename "$0") first_branch second_branch
Show recent common ancestor between 'first_branch' and 'second_branch'
	"
	while [[ $# -gt 0 ]]; do
		case $1 in
			-h|--help)
				echo "${usage}"
				return
			;;
			*)
				POSITIONAL_ARGS+=("$1") # save positional arg
				shift
			;;
		esac
	done
	# restore arguments
	set -- "${POSITIONAL_ARGS[@]}"
	local b1=$1
	if [[ $# -eq 1 ]]; then
		local b2=HEAD
	else
		local b2=$2
	fi
	git merge-base $b1 $b2
}
compdef _JJD-git-branch-names my-git-recent-common-ancestor

function my-git-main-branch-diff() {
	usage="
Usage: $(basename "$0") [branch_name]

Show diff between current branch and 'branch_name' (optional parameter; default = main branch of repository)
Useful for branch reviews
	"
	while [[ $# -gt 0 ]]; do
		case $1 in
			-h|--help)
				echo "${usage}"
				return
			;;
			*)
				POSITIONAL_ARGS+=("$1") # save positional arg
				shift
			;;
		esac
	done
	# restore arguments
	set -- "${POSITIONAL_ARGS[@]}"
	if [[ -z "$1" ]]; then
		REVIEW_BASE="$(git remote show origin | grep 'HEAD branch' | cut -d':' -f2 | tr -d '[:blank:]')"
	else
		REVIEW_BASE="$1"
	fi
	git diff "$(git merge-base HEAD "$REVIEW_BASE")"
}

function my-git-repo-info() {
	_my-print-heading-blue "\nRepo most commits authors:"
	git log --pretty=format:"%an <%ae>" HEAD | sort | uniq -c | sort -nr | head

	_my-print-heading-blue "\nRepo most changed files:"
	git log --all -M -C --name-only --format='format:' "$@" | sort | grep -v '^$' | uniq -c | sort -rn | awk 'BEGIN {print "\tcount\tfile"} {print "\t" $1 "\t" $2}' | head

	_my-print-heading-blue "\nRepo largest files:"
	git rev-list --objects --all |
	git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
	sed -n 's/^blob //p' |
	sort --numeric-sort --key=2 |
	cut -c 1-12,41- |
	numfmt --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest | tail
}

function my-git-checkout-all-branches() {
	# User is not in git repository
	if ! git branch > /dev/null 2>&1
	then
		echo "E: '$(basename ${PWD})' - Not a Git repository."
		exit 1
	fi
	echo "P: Checking out all remote branches..."
	# Remember current branch
	_CURRENT_BRANCH="$(git branch | awk '/^\* / { print $2 }')"
	# Checkout all remote branches
	for _REMOTE_BRANCH in $(git branch -r | awk '{ print $1 }')
	do
		_BRANCH_NAME="$(echo ${_REMOTE_BRANCH} | cut -d/ -f 2-)"
		if [ "${_BRANCH_NAME}" != "HEAD" ]
		then
			if ! git branch | grep -q "${_BRANCH_NAME}$"
			then
				git checkout -b "${_BRANCH_NAME}" "${_REMOTE_BRANCH}"
			fi
		fi
	done
	# Switch back to current branch
	if [ "$(git branch | awk '/^\* / { print $2 }')" != "${_CURRENT_BRANCH}" ]
	then
		exec git checkout "${_CURRENT_BRANCH}"
	fi
}

function my-git-divergence-remote() {
	local CURRENT_BRANCH="$(git branch | grep '^*' | sed s/\*\ //)"
	if [[ "${CURRENT_BRANCH}" != "" ]] {
		TRACKED_REPOSITORY="$(git config branch.${CURRENT_BRANCH}.remote)"
		if [[ "${TRACKED_REPOSITORY}" != "" ]] {
			REMOTE_BRANCH="$(git config branch.${CURRENT_BRANCH}.merge | cut -d"/" -f 3-)"

			if [[ "${REMOTE_BRANCH}" != "" ]] {
				TARGET="${TRACKED_REPOSITORY}/${REMOTE_BRANCH}"
				git fetch ${TRACKED_REPOSITORY} ${REMOTE_BRANCH}>/dev/null 2>&1 || \
					{ >&2 echo -e "\nERROR. Can not fetch ${REMOTE_BRANCH} on ${TRACKED_REPOSITORY}. Exiting..."; return 1 }

				_my-print-heading-blue "\nNot fetched commits on remote tracking branch:"
				git log ..${TARGET}

				_my-print-heading-blue "\nCommits on HEAD not pushed to remote:"
				git log ${TARGET}..

			} else {
				echo "Current branch has no corresponding remote repository."
				echo 'Try setting branch.$CurrentBranch.merge'
			}
		} else {
			echo "Current branch doesn't track any repository."
			echo 'Try setting branch.$CurrentBranch.remote'
		}
	}
}
