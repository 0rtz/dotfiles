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
}
