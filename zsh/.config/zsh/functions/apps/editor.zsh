# Smart editor open
function my-editor-open() {
	if (( $# == 0 )); then
		$EDITOR
		return
	fi

	local file="$1"

	# Handle file:line syntax (e.g. main.go:42)
	if [[ "$file" =~ :[0-9]+$ ]]; then
		local filename="${file%:*}"
		local line="${file##*:}"
		$EDITOR "+$line" "$filename"
		return
	fi

	# Create file and missing parent directories if needed
	if [[ ! -f "$file" ]]; then
		local dir="${file:h}"
		if [[ ! -d "$dir" ]]; then
			mkdir -p "$dir"
			echo "Created $dir"
		fi
		touch "$file"
	else
		# Large files (>1MB) open without config for speed
		local size=$(wc -c < "$file")
		if (( size > 1000000 )); then
			nvim -u NONE "$file"
			return
		fi
	fi

	$EDITOR "$file"
}

# Create and edit a temporary file, print its path
function my-create-edit-tmp() {
	local tmp=$(mktemp)
	$EDITOR "$tmp"
	echo "$tmp"
}

# Create a new executable script
# Usage: my-create-script [filename]
function my-create-script() {
	local file="$1"

	# Generate random name if not provided
	if [[ -z "$file" ]]; then
		file=$(head -c 4 /dev/urandom | xxd -p)
	fi

	if [[ -e "$file" ]]; then
		my-editor-open "$file"
		return
	fi

	# Strip path, add .sh extension if none
	file="${file:t}"
	[[ -z "${file:e}" ]] && file="$file.sh"

	printf '#!/bin/bash\n\n' > "$file"
	chmod +x "$file"
	$EDITOR + "$file"
	echo "$file created"
}

# VS Code / Windsurf wrapper with large file handling
function my-vscode-open() {
	local cmd
	if (( ${+commands[windsurf]} )); then
		cmd=windsurf
	elif (( ${+commands[code]} )); then
		cmd=code
	else
		my-editor-open "$@"
		return
	fi

	if (( $# == 0 )); then
		$cmd -n . &!
		return
	fi

	# Large files: open in nvim without config
	local size=$(wc -c < "$1")
	if (( size > 1000000 )); then
		nvim -u NONE "$1"
		return
	fi

	$cmd -n --goto "$1" &!
}
