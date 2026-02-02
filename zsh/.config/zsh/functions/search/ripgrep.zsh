# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#switching-between-ripgrep-mode-and-fzf-mode
function my-ripgrep-fzf() {
	local rg_prefix="rg --column --line-number --hidden --no-heading --color=always --smart-case"
	local initial_query="${*:-}"


	if (( ${+commands[bat]} )); then
		local rg_file fzf_file
		rg_file=$(mktemp)
		fzf_file=$(mktemp)
		trap 'rm -f "$rg_file" "$fzf_file"' EXIT

		fzf --ansi --disabled --query "$initial_query" \
			--bind "start:reload:$rg_prefix {q}" \
			--bind "change:reload:sleep 0.1; $rg_prefix {q} || true" \
			--bind "ctrl-f:transform:[[ ! \$FZF_PROMPT =~ ripgrep ]] &&
				echo \"rebind(change)+change-prompt(1. ripgrep> )+disable-search+transform-query:echo \{q} > $fzf_file; cat $rg_file\" ||
				echo \"unbind(change)+change-prompt(2. fzf> )+enable-search+transform-query:echo \{q} > $rg_file; cat $fzf_file\"" \
			--prompt '1. ripgrep> ' \
			--delimiter ':' \
			--header 'CTRL-F: Switch between ripgrep/fzf' \
			--preview 'bat --color=always {1} --highlight-line {2}' \
			--preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
			--bind 'enter:become(nvim {1} +{2})'
	else
		FZF_DEFAULT_COMMAND="$rg_prefix '$initial_query'" \
			fzf --ansi --disabled \
			--bind "change:reload:$rg_prefix {q} || true" |
			cut -d":" -f1-2 | my-yank-to-clipboard
	fi
}

# Searches inside PDFs, docs, archives, etc.
function my-ripgrep-all-fzf() {
	if [[ -z "$1" ]]; then
		echo "Usage: my-ripgrep-all-fzf <pattern>"
		return 1
	fi

	if ! (( ${+commands[rga]} )); then
		>&2 echo "ERROR: rga (ripgrep-all) is not installed"
		return 1
	fi

	local rg_prefix="rga --files-with-matches"
	local file

	file="$(
		FZF_DEFAULT_COMMAND="$rg_prefix '$1'" \
			fzf --sort --phony -q "$1" \
				--bind "change:reload:$rg_prefix {q}" \
				--preview="rga --pretty --context 5 {q} {}" \
				--preview-window="70%:wrap"
	)" || return

	echo "Opening $file"
	xdg-open "$file"
}