# Create Python venv with direnv integration
# Usage: my-create-python-env [env_name] (default: .venv)
function my-create-python-env() {
	local env_name="${1:-.venv}"

	if [[ -d "$env_name" ]]; then
		echo "Virtual environment '$env_name' already exists."
		return 1
	fi

	python -m venv "$env_name"
	echo "source $env_name/bin/activate" > .envrc
	direnv allow

	echo "Created Python venv '$env_name' with direnv"
}