my-replace-recursive() {
	emulate -L zsh
	set -o errexit -o nounset -o pipefail

	local dry_run=0

	# ---- option parsing ----
	while [[ $# -gt 0 ]]; do
		case "$1" in
			-n|--dry-run)
				dry_run=1
				shift
				;;
			-h|--help)
				cat <<'EOF'
Usage:
	my-replace-recursive [OPTIONS] <old_string> <new_string> [target_dir]

Description:
	Recursively replace text in files using ripgrep (rg) and sd.

Options:
	-n, --dry-run	Show what would be changed without modifying files
	-h, --help	Show this help message

Examples:
	my-replace-recursive foo bar
	my-replace-recursive -n foo bar src/
	my-replace-recursive --dry-run "old name" "new name" .
EOF
				return 0
				;;
			--)
				shift
				break
				;;
			-*)
				print -u2 "Unknown option: $1"
				return 1
				;;
			*)
				break
				;;
		esac
	done

	# ---- positional args ----
	local old_string="${1:-}"
	local new_string="${2:-}"
	local target_dir="${3:-.}"

	if [[ -z $old_string || -z $new_string ]]; then
		print -u2 "Error: missing required arguments"
		print -u2 "Try: my-replace-recursive --help"
		return 1
	fi

	if (( dry_run )); then
		print "DRY RUN: '$old_string' → '$new_string' in $target_dir"
	else
		print "Replacing '$old_string' → '$new_string' in $target_dir"
	fi

	# ---- processing ----
	while IFS= read -r file; do
		if (( dry_run )); then
			print "[DRY RUN] $file"
			sd --dry-run "$old_string" "$new_string" -- "$file"
		else
			print "Processing: $file"
			sd "$old_string" "$new_string" -- "$file"
		fi
	done < <(
		rg --files-with-matches \
			--hidden \
			--text \
			--glob '!.git/*' \
			"$old_string" "$target_dir"
	)
}
