# Set or show git user.name and user.email for current repo
function my-git-repo-config() {
	if ! git rev-parse --git-dir &>/dev/null; then
		>&2 echo "ERROR: Not a git repository"
		return 1
	fi

	if [[ $1 == -h || $1 == --help ]]; then
		echo "Usage: my-git-edit-config <name> <email>"
		echo "       my-git-edit-config   # show current repo identity"
		return 0
	fi

	if (( $# == 0 )); then
		echo "Name:  $(git config user.name)"
		echo "Email: $(git config user.email)"
		return 0
	fi

	if (( $# < 2 )); then
		>&2 echo "ERROR: Specify both name and email"
		return 1
	fi

	git config user.name "$1"
	git config user.email "$2"

	echo "Updated repository identity:"
	echo "Name:  $(git config user.name)"
	echo "Email: $(git config user.email)"
}

# Show repository statistics
function my-git-repo-info() {
	if ! git rev-parse --git-dir &>/dev/null; then
		>&2 echo "ERROR: Not a git repository"
		return 1
	fi

	_my-print-heading-blue "\nTop commit authors:"
	git log --all --pretty=format:"%an <%ae>" |
		sort | uniq -c | sort -nr | head

	_my-print-heading-blue "\nLatest local branches:"
	git for-each-ref --sort=-committerdate \
		--format='%(committerdate:relative)  %(refname:short)' \
		refs/heads

	_my-print-heading-blue "\nMost changed files:"
	git log --all -M -C --name-only --format='format:' |
		grep -v '^$' |
		sort | uniq -c | sort -rn |
		awk 'BEGIN {print "\tcount\tfile"} {print "\t" $1 "\t" $2}' |
		head

	_my-print-heading-blue "\nLargest blobs (history):"
	git rev-list --objects --all |
		git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
		awk '$1=="blob" {print $3 "\t" $4}' |
		sort -nr |
		head |
		while read -r size file; do
			printf "\t%8s  %s\n" "$(numfmt --to=iec-i --suffix=B "$size" 2>/dev/null || echo "${size}B")" "$file"
		done
}