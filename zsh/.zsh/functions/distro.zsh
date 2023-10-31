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
