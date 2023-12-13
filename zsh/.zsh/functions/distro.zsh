function my-packages-list ()
{
	if command -v pacman > /dev/null; then
		if [[ -n $1 ]]; then
			local package=$1
			if ! pacman -Qi $package >/dev/null 2>&1; then
				>&2 echo -e "ERROR: Package $package not found. Exiting..."
				return 1
			fi
		else
			local package=$(pacman -Qq | fzf --preview-window=wrap --preview 'pacman -Qil {}' --layout=reverse)
			if [[ -z $package ]]; then
				return
			fi
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

function my-packages-install ()
{
	if command -v pacman > /dev/null; then
		all_pkgs=($(pacman -Slq))

		if [[ $# -gt 0 ]]; then
			local pkgs=("$@")
			for pkg in "${pkgs[@]}"
			do
				if ! (($all_pkgs[(Ie)$pkg])); then
					>&2 echo -e "ERROR: Package $pkg not found. Exiting..."
					return 1
				fi
			done
		else
			local pkgs=($( printf '%s\n' "${all_pkgs[@]}" | fzf --multi --preview-window=wrap --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk "{print \$2}")'))
			if [[ -z $pkgs ]]; then
				return
			fi
		fi

		sudo pacman -S "${pkgs[@]}"
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

function my-packages-not-in-repo()
{
	if command -v pacman > /dev/null 2>&1 ; then
		pacman -Qm
	fi
}

function my-package-dependencies()
{
	if command -v pacman > /dev/null 2>&1 ; then
		if ! command -v "pactree" > /dev/null 2>&1 ; then
			 >&2 echo "ERROR: pactree not found. Install pacman-contrib package. Exiting..."
			return 1
		fi
		pactree $1
	fi
}
function my-package-dependencies-reverse()
{
	if command -v pacman > /dev/null 2>&1 ; then
		if ! command -v "pactree" > /dev/null 2>&1 ; then
			 >&2 echo "ERROR: pactree not found. Install pacman-contrib package. Exiting..."
			return 1
		fi
		pactree -r $1
	fi
}
_JJD-my-packages() {
	compadd "${(@f)$(pacman -Qq)}"
}
compdef _JJD-my-packages my-package-dependencies
compdef _JJD-my-packages my-package-dependencies-reverse
