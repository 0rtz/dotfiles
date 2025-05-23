function my-create-pyton-env() {
	if [[ -d $PWD/.venv ]]; then
		>&2 echo -e "ERROR: $PWD/.venv already exist. Exiting..."
		return 1
	fi
	python3 -m venv .venv

	if [[ -f $PWD/.envrc ]]; then
		>&2 echo -e "ERROR: $PWD/.envrc already exist. Exiting..."
		return 1
	fi
cat << EOF > .envrc
source .venv/bin/activate
EOF
	direnv allow . && exec zsh
}

function my-shared-libs-fzf() {
	declare -A shared_libs
	shared_libs=()
	for filename in /proc/[0-9]*; do
		local libs=(`cat "$filename"/maps 2>/dev/null  | awk '{print $6;}' | grep '\.so' | uniq`)
		for i in "${libs[@]}"
		do
			((shared_libs[$i]++))
		done
	done
	print -l ${(k)shared_libs} | fzf --preview-label="Processes opened shared lib:" --preview='lsof -H {}' | xargs --no-run-if-empty lsof -H
}
