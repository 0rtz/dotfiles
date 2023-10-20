####################################################################################
### general

function my-yank-to-clipboard() {
	# if arguments were specified treat it as file names
	if [ $# -gt 0 ]; then
		local file_list=()
		for file in $@; do
			if [[ -d $file ]]; then
				for entry in $file/**/*(.);
				do
					file_list+="$entry"
				done
			elif [[ -f $file ]]; then
				file_list+="$file"
			else
				>&2 echo -e "\nERROR. File $file does not exist. Exiting..."; return 1
				return 1
			fi
		done
		if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
			wl-copy --trim-newline < $file_list
		else
			xclip -rmlastnl -selection clipboard $file_list
		fi
		print -l "files:\n" "$file_list[@]" "\ncontent copied to clipboard"
	else
		# if data was piped copy it from stdin
		if [ -p /dev/stdin ];then
			local data=""
			local stdin=$(</dev/stdin)
			if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
				echo -n "$stdin" | wl-copy
				data="$(wl-paste)"
			else
				echo -n "$stdin" | xclip -in -selection clipboard
				data="$(xclip -out -selection clipboard)"
			fi
			if [ "$data" != "" ]; then
				if (( $(grep -c . <<<"$data") > 1 )); then
					echo -e "$data\n\ncopied to clipboard"
				else
					echo -e "$data copied to clipboard"
				fi
			fi
		fi
	fi
}

function n() {
	# Block nesting of nnn in subshells
	if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
		echo "nnn is already running"
		return
	fi

	# -c) cli‐only opener ($NNN_OPENER)
	# -a) multiple NNN_FIFO for previewers
	# -H) show hidden files by default
	# -T 't') sort by time accessed by default
	# -i) show current file info in info bar
	# -U) show user and group names
	# -g) fuzzy(regex) file search match
	# -A) do not open dir if is the only match in search
	# -Q) no quit confirmation on <Ctrl-G>
	nnn -c -a -H -T 't' -i -U -g -A -Q "$@"

	# cd on quit
	if [ -f "$NNN_TMPFILE" ]; then
			. "$NNN_TMPFILE"
			rm -f "$NNN_TMPFILE" > /dev/null
	fi
}

function my-editor-open () {
	if [ $# -eq 0 ]
	then
		$EDITOR
	else
		if echo $1 | grep -q -E ":[[:digit:]]+$"; then
			local filename=$(echo $1 | cut -d':' -f1)
			local line=$(echo $1 | cut -d':' -f2)
			$EDITOR +${line} ${filename}
		else
			if [ ! -f $1 ]; then
				local dir=$(dirname $1)
				if [[ ! -d $dir ]]; then
					mkdir -p ${dir}
					echo "Created $dir"
				fi
				touch $1
			else
				local size
				size=$(wc -c < $1)
				if (( size > 1000000 )); then
					nvim -u NONE $1
					return
				fi
			fi
			$EDITOR $1
		fi
	fi
}

function my-create-edit-tmp() {
	local TMP=$(mktemp)
	$EDITOR ${TMP}
	echo ${TMP}
}

function my-create-script() {
	local file=$1
	if [ ! -e "$file" ]; then
		if [ -z "$file" ]; then
			file="$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 8)"
		fi
		# zshexpn(1): HISTORY EXPANSION -> Modifiers
		file=$file:t
		if [[ -z "$file:e" ]]; then
			file="$file".sh
		fi
		echo -e '#!/bin/bash\n\n' > "$file"
		chmod +x $file
		$EDITOR + "$file"
		echo "$file created"
	else
		my-editor-open "$file"
	fi
}

function my-eval-var() {
	echo -e "cmd:\n\n******************************\n${(P)1}\n******************************\n"
	if read -q "choice?Execute: y/n? "; then
		echo
		eval "${(P)1}"
	else
		print "\nAborting..."
	fi
}
compdef _vars my-eval-var

function my-tmux-session-create-run-cmd()
{
	if [[ "$#" -eq 0 ]]; then
		>&2 echo -e "\nERROR. Specify command to run. Exiting..."; return 1
	fi
	SESSION_NAME=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 8)
	tmux new-session -d -s $SESSION_NAME
	tmux send-keys -t $SESSION_NAME.0 "$@" C-m
	if [[ -z "${TMUX}" ]]; then
		tmux attach-session -t $SESSION_NAME
	else
		echo "Session $SESSION_NAME created"
	fi
}
compdef _path_commands my-tmux-session-create-run-cmd

function my-tmux-session-run-cmd()
{
	if [[ "$#" -eq 0 ]]; then
		>&2 echo -e "\nERROR. Specify command to run. Exiting..."; return 1
	fi
	SESSION_NAME=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 8)
	tmux new-session -d -s $SESSION_NAME "$@"
	if [[ -z "${TMUX}" ]]; then
		tmux attach-session -t $SESSION_NAME
	else
		echo "Session $SESSION_NAME created"
	fi
}
compdef _path_commands my-tmux-session-run-cmd

function my-packages-list ()
{
	if command -v pacman > /dev/null; then
		if [[ -n $1 ]]; then
			local package=$1
		else
			local package=$(pacman -Qq | fzf --preview-window=wrap --preview 'pacman -Qil {}' --layout=reverse)
		fi
		if [[ -z $package ]]; then
			return
		fi
		if ! pacman -Qi $package >/dev/null 2>&1; then
			>&2 echo -e "ERROR: Package $package not found. Exiting..."
			return 1
		fi
		local package_files=$(pacman -Qlq $package | grep -v "/$")
		local package_files_listed

		if command -v exa > /dev/null; then
			package_files_listed=$(echo "$package_files" | xargs -r -d "\n" exa --sort=size --reverse -aglbh --icons --color always)
		else
			package_files_listed=$(echo "$package_files" | xargs -r -d "\n" ls -lAFh --color=tty)
		fi
		{ pacman -Qi $package; echo $package_files_listed; } | less -r
	fi
}

function my-packages-size()
{
	if command -v pacman > /dev/null 2>&1 ; then
		if ! command -v expac > /dev/null 2>&1 ; then
			>&2 echo "expac not found"
			exit 1
		else
			expac "%n %m" | sort -gk2 | awk '{sum+=$2; printf "%-30s%20.2f MiB\n", $1, $2/2^20} END {printf "----------\n%-30s%20.2f GiB\n", "Total:", sum/2^30}'
		fi
	fi
}

function my-packages-latest()
{
	if command -v pacman > /dev/null 2>&1 ; then
		pacman -Qe | expac --timefmt='%Y-%m-%d %T' '%l\t%n' - | sort
	fi
}

function my-packages-orphan()
{
	if command -v pacman > /dev/null 2>&1 ; then
		pacman -Qtdq
	fi
}

####################################################################################


####################################################################################
### fzf

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

####################################################################################


####################################################################################
### desktop

function my-notfiy-wrapper() {
	start=$(date +%s)
	"$@"
	notify-send "Command \"$(echo $@)\" completed" "duration: $(($(date +%s) - start)) seconds"
}

function my-pick-color() {
	grim -g "$(slurp -p)" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:- | tail -n 1 | cut -d ' ' -f 4
}

####################################################################################


####################################################################################
### programming

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

####################################################################################


####################################################################################
### git

function my-add-git-remote() {
	git remote add $1 $2
	git fetch $1
}

# $1 = Branch name to create on remote (Required parameter)
# $2 = Remote name to create branch on (Optional parameter)
function my-git-create-branch-remote() {
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

# $1 = Branch name to delete on remote (Required parameter)
# $2 = Remote name to delete branch on (Optional parameter)
function my-git-delete-branch-remote() {
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
_JJD-git-branch-names() {
	compadd "${(@)${(f)$(git branch)}#??}"
}
compdef _JJD-git-branch-names my-git-delete-branch-remote

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
	git config user.name "$1";
	git config user.email "$2";
	echo "New git repo name: "; git config user.name
	echo "New git repo email: "; git config user.email
}

# move branch to current HEAD and cherry pick it's last commit from previous position
function my-git-move-on-current-cherrypick-last() {
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

function my-git-list-large() {
	git rev-list --objects --all |
	git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
	sed -n 's/^blob //p' |
	sort --numeric-sort --key=2 |
	cut -c 1-12,41- |
	$(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
}

####################################################################################


####################################################################################
### networking

function my-networking-server-notify-alive() {
	until ping -w 10 -c 2 $1 > /dev/null 2>&1
	do
	done
	notify-send "$1 is alive"
}
compdef my-networking-server-notify-alive=ping

function my-networking-ssh-server-notify-alive() {
	until ssh $1 'exit' > /dev/null 2>&1
	do
	done
	notify-send "$1 is alive"
}
compdef my-networking-ssh-server-notify-alive=ping

function my-networking-ip ()
{
	if command -v curl > /dev/null; then
		curl -s http://ipecho.net/plain; echo
		return
	fi
	if command -v wget > /dev/null; then
		wget -q -O - http://ipecho.net/plain 2>&1; echo
		return
	fi
	>&2 echo -e "\nERROR. Install curl or wget. Exiting..."
	return 1
}

####################################################################################
