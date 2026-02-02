function my-replace-recursive() {
	local old_string="$1"
	local new_string="$2"
	local target_dir="${3:-.}"

	if [[ -z "$old_string" || -z "$new_string" ]]; then
		echo "Usage: my-replace-recursive <old_string> <new_string> [target_dir]"
		return 1
	fi

	echo "Replacing '$old_string' with '$new_string' in $target_dir"
	rg --files-with-matches --hidden "$old_string" "$target_dir" | while read -r file; do
		echo "Processing: $file"
		sed -i "s/$old_string/$new_string/g" "$file"
	done
}