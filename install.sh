#!/bin/bash

function check_prog() {
	for prg in "$@"
	do
		if ! hash "$prg" > /dev/null 2>&1; then
			echo "Command not found: $prg. Aborting..."
			exit 1
		fi
	done
}

term_configs=(zsh nnn nvim tmux)
desktop_configs=(desktop alacritty)

function install_term() {
	for e in "${term_configs[@]}"; do
		stow --verbose=2 --target "$HOME" "$e"|| { echo -e "\n\nError: stow terminal failed" >&2; exit 1; }
	done
	echo -e "\n\nvim plugins:\n"
	nvim --headless +PlugInstall +qall
	mkdir -p ~/.config/nvim
	# create dictionary for 'uga-rosa/cmp-dictionary' vim plugin
	aspell -d en dump master | aspell -l en expand > ~/.config/nvim/en.dict
	echo -e "\n\ntmux plugins:\n"
	./tmux/.config/tmux/plugins/tpm/bin/install_plugins
	echo -e "\n\nzsh plugins and theme:\n"
	zsh -ic "fast-theme XDG:overlay"
}

function install_desktop() {
	for e in "${desktop_configs[@]}"; do
		stow --verbose=2 --target "$HOME" "$e" || { echo -e "\n\nError: stow desktop failed" >&2; exit 1; }
	done
}

function update() {
	local -a submodules_paths
	local is_init=true
	cd "$(dirname "$0")" || { echo "cd failure" >&2; exit 1; }
	IFS=$'\n' read -r -d '' -a submodules_paths < <( git config --file .gitmodules --path --get-regexp 'submodule.*.path$' | cut -d " " -f 2 )
	for i in "${submodules_paths[@]}"
	do
		if ! ls "$i"/.git >/dev/null 2>&1 ; then
			echo >&2 "$i module not initialized."
			is_init=false
		fi
	done
	if [ "$is_init" = true ]; then
		if [ -f "$HOME/.config/nvim/init.vim" ]; then
			echo -e "\n\nvim plugins:\n"
			nvim --headless +PlugUpdate +qall
		fi
		if [ -f "$HOME/.config/tmux/tmux.conf" ]; then
			echo -e "\n\ntmux plugins:\n"
			./tmux/.config/tmux/plugins/tpm/bin/update_plugins all
		fi
		if [ -f "$HOME/.zshrc" ]; then
			echo -e "\n\nzsh plugins:\n"
			zsh -i -c "zinit update --parallel | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g'"
			zsh -i -c "zinit self-update | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g'"
		fi
	else
		echo "Initializing repo submodules..."
		git submodule update --checkout --init --jobs "$(nproc)" --depth 1
	fi
}

function clear() {
	for e in "${term_configs[@]}"; do
		stow --verbose=2 -D --target "$HOME" "$e"
	done
	for e in "${desktop_configs[@]}"; do
		stow --verbose=2 -D --target "$HOME" "$e"
	done
}

function check_health() {
	printf "Lines of colors should be continuous:\n"
	curl -s https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh | bash
	zsh -i -c "echo 123 | my-yank-to-clipboard "
}

usage="
$(basename "$0") [TYPE || OPTION]

script to install dotfiles

TYPE:
	-t | --term
		link dotfiles for programs that are available through terminal interface
		install plugins with (nvim, tmux, zsh) plugin manager

	-d | --desktop
		link dotfiles for desktop programs

OPTION:
	-u | --update
		update:
			nvim plugins
			tmux plugins
			zsh plugins
		or initialize git submodules if they are not initialized already

	-c | --clear
		unlink configuration files from \$HOME

	--checkhealth
		check whether everything set up right
"

CLI=0
DESK=0
while (( $# )); do
	case "$1" in
		-t|--term)
			CLI=1
			shift
			;;
		-d|--desktop)
			DESK=1
			shift
			;;
		-h|--help)
			echo "$usage"
			exit
			;;
		-u|--update)
			update
			exit
			;;
		--checkhealth)
			check_health
			exit
			;;
		-c|--clear)
			clear
			exit
			;;
		-*)
			echo "Error: Unsupported flag $1" >&2
			exit 1
			;;
	esac
done

if [[ $CLI -eq 0 && $DESK -eq 0 ]]
then
	echo "Error: specify --term or --desktop flags" >&2
	exit 1
fi

check_prog stow curl zsh nvim tmux

if [[ $CLI -ne 0 ]]
then
	install_term
fi
if [[ $DESK -ne 0 ]]
then
	install_desktop
fi
