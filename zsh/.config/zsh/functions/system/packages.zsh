# Detect package manager (cached for session)
_my_pkg_manager=""
function _my-detect-pkg-manager() {
	[[ -n "$_my_pkg_manager" ]] && return 0

	if (( ${+commands[pacman]} )); then
		_my_pkg_manager="pacman"
	elif (( ${+commands[apt]} )); then
		_my_pkg_manager="apt"
	elif (( ${+commands[dnf]} )); then
		_my_pkg_manager="dnf"
	elif (( ${+commands[zypper]} )); then
		_my_pkg_manager="zypper"
	else
		>&2 echo "ERROR: No supported package manager found"
		return 1
	fi
}

# Completion helper for installed packages (PM agnostic)
_JJD-my-packages() {
	_my-detect-pkg-manager || return 1
	compadd "${(@f)$(_my-packages-list-names)}"
}

# Browse installed packages with fzf preview
function my-packages-list() {
	_my-detect-pkg-manager || return 1

	if ! command -v fzf >/dev/null; then
		>&2 echo "ERROR: fzf is required"
		return 1
	fi

	case "$_my_pkg_manager" in
		pacman)
			pacman -Qq |
				fzf --preview 'pacman -Qi {}' \
					--prompt "Installed package> " \
					--bind 'enter:execute(pacman -Qil {} | less)'
			;;
		apt)
			dpkg-query -W -f='${Package}\n' |
				fzf --preview 'apt-cache show {}' \
					--prompt "Installed package> " \
					--bind 'enter:execute(dpkg -L {} | less)'
			;;
		dnf)
			dnf list installed --quiet | tail -n +2 | awk '{print $1}' |
				fzf --preview 'dnf info {}' \
					--prompt "Installed package> " \
					--bind 'enter:execute(rpm -ql {} | less)'
			;;
		zypper)
			zypper se -i | tail -n +5 | awk '{print $3}' |
				fzf --preview 'zypper info {}' \
					--prompt "Installed package> "
			;;
	esac
}

# Search and install packages from repos
function my-packages-install() {
	_my-detect-pkg-manager || return 1

	if ! command -v fzf >/dev/null; then
		>&2 echo "ERROR: fzf is required"
		return 1
	fi

	local packages
	case "$_my_pkg_manager" in
		pacman)
			packages=$(pacman -Slq | fzf --multi --preview 'pacman -Si {1}' \
				--prompt "Install package> " \
				--header "Tab to select multiple") || return
			[[ -n "$packages" ]] && echo "$packages" | xargs -ro sudo pacman -S
			;;
		apt)
			packages=$(apt-cache pkgnames | fzf --multi --preview 'apt-cache show {}' \
				--prompt "Install package> " \
				--header "Tab to select multiple") || return
			[[ -n "$packages" ]] && echo "$packages" | xargs -ro sudo apt install
			;;
		dnf)
			packages=$(dnf list available --quiet | tail -n +2 | awk '{print $1}' |
				fzf --multi --preview 'dnf info {}' \
				--prompt "Install package> " \
				--header "Tab to select multiple") || return
			[[ -n "$packages" ]] && echo "$packages" | xargs -ro sudo dnf install
			;;
		zypper)
			packages=$(zypper se | tail -n +5 | awk '{print $3}' |
				fzf --multi --preview 'zypper info {}' \
				--prompt "Install package> " \
				--header "Tab to select multiple") || return
			[[ -n "$packages" ]] && echo "$packages" | xargs -ro sudo zypper install
			;;
	esac
}

# Show recently installed/updated packages
function my-packages-latest() {
	_my-detect-pkg-manager || return 1

	local count="${1:-20}"

	case "$_my_pkg_manager" in
		pacman)
			if ! (( ${+commands[expac]} )); then
				>&2 echo "ERROR: expac is required for pacman"
				return 1
			fi
			expac --timefmt='%Y-%m-%d %T' '%l\t%n' |
				sort -r | head -n "$count" | column -t -s $'\t'
			;;
		apt)
			grep -E "install |upgrade " /var/log/dpkg.log 2>/dev/null |
				tail -n "$count" | awk '{print $1, $2, $4}'
			;;
		dnf)
			dnf history list --reverse | tail -n "$count"
			;;
		zypper)
			zypper search --installed-only --sort-by-repo |
				head -n "$count"
			;;
	esac
}

# Find and remove orphan packages (unused dependencies)
function my-packages-orphan() {
	_my-detect-pkg-manager || return 1

	local orphans
	case "$_my_pkg_manager" in
		pacman)
			orphans=$(pacman -Qtdq 2>/dev/null)
			;;
		apt)
			orphans=$(apt-get autoremove --dry-run 2>/dev/null |
				grep -oP 'Remv \K[^ ]+')
			;;
		dnf)
			orphans=$(dnf autoremove --assumeno 2>/dev/null |
				awk '/^Removing:/{found=1; next} found && /^$/{found=0} found{print $1}')
			;;
		zypper)
			orphans=$(zypper packages --unneeded 2>/dev/null |
				tail -n +5 | awk '{print $5}')
			;;
	esac

	if [[ -z "$orphans" ]]; then
		echo "No orphan packages found."
		return 0
	fi

	if ! command -v fzf >/dev/null; then
		echo "$orphans"
		return 0
	fi

	local selected
	selected=$(echo "$orphans" |
		fzf --multi \
			--prompt "Remove orphan> " \
			--header 'Tab to select multiple') || return

	[[ -z "$selected" ]] && return

	case "$_my_pkg_manager" in
		pacman) echo "$selected" | xargs -ro sudo pacman -Rns ;;
		apt)    echo "$selected" | xargs -ro sudo apt remove ;;
		dnf)    echo "$selected" | xargs -ro sudo dnf remove ;;
		zypper) echo "$selected" | xargs -ro sudo zypper remove ;;
	esac
}

# List foreign packages (AUR, manual installs, etc.)
function my-packages-not-in-repo() {
	_my-detect-pkg-manager || return 1

	local foreign
	case "$_my_pkg_manager" in
		pacman)
			foreign=$(pacman -Qm)
			;;
		apt)
			foreign=$(apt list --installed 2>/dev/null |
				grep -v "^\(apt\|ubuntu\|debian\)" | cut -d/ -f1)
			;;
		dnf)
			foreign=$(dnf list installed 2>/dev/null |
				grep -v '@' | tail -n +2 | awk '{print $1}')
			;;
		*)
			echo "Not supported for $_my_pkg_manager"
			return 1
			;;
	esac

	if ! command -v fzf >/dev/null; then
		echo "$foreign"
		return 0
	fi

	echo "$foreign" | fzf --prompt "Foreign package> "
}

# Show package dependency tree
function my-package-dependencies() {
	_my-detect-pkg-manager || return 1

	local package="$1"

	if [[ -z "$package" ]] && command -v fzf >/dev/null; then
		package=$(_my-packages-list-names | fzf --prompt "Package> ") || return
	fi

	[[ -z "$package" ]] && return 1

	case "$_my_pkg_manager" in
		pacman)
			if ! command -v pactree >/dev/null; then
				>&2 echo "ERROR: pactree required (pacman-contrib)"
				return 1
			fi
			pactree -c "$package"
			;;
		apt)
			apt-cache depends "$package"
			;;
		dnf)
			dnf repoquery --requires "$package"
			;;
		zypper)
			zypper info --requires "$package"
			;;
	esac
}
compdef _JJD-my-packages my-package-dependencies

# Show reverse dependencies (what depends on this package)
function my-package-dependencies-reverse() {
	_my-detect-pkg-manager || return 1

	local package="$1"

	if [[ -z "$package" ]] && command -v fzf >/dev/null; then
		package=$(_my-packages-list-names | fzf --prompt "Package> ") || return
	fi

	[[ -z "$package" ]] && return 1

	case "$_my_pkg_manager" in
		pacman)
			if ! command -v pactree >/dev/null; then
				>&2 echo "ERROR: pactree required (pacman-contrib)"
				return 1
			fi
			pactree -r -c "$package"
			;;
		apt)
			apt-cache rdepends "$package"
			;;
		dnf)
			dnf repoquery --whatrequires "$package"
			;;
		zypper)
			zypper search --requires "$package"
			;;
	esac
}
compdef _JJD-my-packages my-package-dependencies-reverse

# Helper: list installed package names
function _my-packages-list-names() {
	case "$_my_pkg_manager" in
		pacman) pacman -Qq ;;
		apt)    dpkg-query -W -f='${Package}\n' ;;
		dnf)    rpm -qa --qf '%{NAME}\n' ;;
		zypper) zypper se -i | tail -n +5 | awk '{print $3}' ;;
	esac
}
