function my-man-fzf() {
	man -k . \
	| fzf -n1,2 --preview "echo {} \
	| cut -d' ' -f1 \
	| sed 's# (#.#' \
	| sed 's#)##' \
	| xargs -I% man %" --bind "enter:execute: \
	  (echo {} \
	  | cut -d' ' -f1 \
	  | sed 's# (#.#' \
	  | sed 's#)##' \
	  | xargs -I% man % \
	  | less)"
}

function my-zsh-keymaps-insert-fzf() {
	bindkey -M viins | fzf
}

function my-zsh-keymaps-normal-fzf() {
	bindkey -M vicmd | fzf
}

function my-yank-fzf() {
	if [ -p /dev/stdin ]  # if data was piped
	then
		stdin=$(</dev/stdin)
		echo "$stdin" | fzf "$@" | my-yank-to-clipboard
	else
		fzo=$(fzf "$@")
	fi
}

function my-ripgrep-fzf() {
	if command -v bat > /dev/null; then
	rm -f /tmp/rg-fzf-{r,f}
	RG_PREFIX="rg --column --line-number --hidden --no-ignore --no-heading --color=always --smart-case "
	INITIAL_QUERY="${*:-}"
	: | fzf --ansi --disabled --query "$INITIAL_QUERY" \
		--bind "start:reload($RG_PREFIX {q})+unbind(ctrl-r)" \
		--bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
		--bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)" \
		--bind "ctrl-r:unbind(ctrl-r)+change-prompt(1. ripgrep> )+disable-search+reload($RG_PREFIX {q} || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
		--color "hl:-1:underline,hl+:-1:underline:reverse" \
		--prompt '1. ripgrep> ' \
		--delimiter : \
		--header '╱ CTRL-R (ripgrep mode) ╱ CTRL-F (fzf mode) ╱' \
		--preview 'bat --theme="ansi" --color=always {1} --highlight-line {2}' \
		--preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
		--bind 'enter:become(nvim -c "normal zv" {1} +{2})'
	else
		INITIAL_QUERY=""; \
		RG_PREFIX="rg --column --line-number --hidden --no-ignore --no-heading --color=always --smart-case "; \
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'"; \
		  fzf --bind "change:reload:$RG_PREFIX {q} || true" \
		  --ansi --color=light --disabled --query "$INITIAL_QUERY" \
		  --height=50% --layout=reverse | cut -d":" -f1-2 | my-yank-to-clipboard
	fi
}

function rga-fzf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}

function my-processes-fzf() {
	if [[ -z $1 ]]; then
		>&2 echo -e "ERROR: Specify PID or process name. Exiting..."
		return 1
	fi
	local regex_number='^[0-9]+$'
	if [[ $1 =~ $regex_number ]] ; then
		OUT=$(ps -wwo "pid,wchan,cmd" -p $1)
	else
		OUT=$(ps -wwo "pid,wchan,cmd" -p $(pgrep $1))
	fi
	if [[ $? -gt 0 ]]; then
		return 1
	fi
	echo "$OUT"
}
compdef my-processes-fzf=pgrep

function my-powermenu-fzf () {
	op=$( echo -e " Poweroff\n Suspend\n Reboot\n Lock\n Logout" | fzf | awk '{print tolower($2)}' )
	case $op in
		poweroff)
			;&
		suspend)
			;&
		reboot)
			systemctl $op
			;;
		lock)
			swaylock --indicator-idle-visible
			;;
		logout)
			swaymsg exit
			;;
	esac
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

function my-kernel-modules-fzf() {
	local loaded_modules=("${(@f)$(lsmod | tail -n +2 | awk '{ print $1 }')}")
	print -l "${loaded_modules[@]}" | fzf --preview-label="Kernel module modinfo:" --preview='modinfo {}' | xargs --no-run-if-empty modinfo
}
