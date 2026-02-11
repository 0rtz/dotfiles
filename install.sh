#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

TERM_PACKAGES=(zsh nvim tmux yazi)
DESKTOP_PACKAGES=(desktop)
ALL_PACKAGES=("${TERM_PACKAGES[@]}" "${DESKTOP_PACKAGES[@]}")

# --- Logging ---

info()    { printf '\033[1;34m::\033[0m %s\n' "$*"; }
success() { printf '\033[1;32m::\033[0m %s\n' "$*"; }
error()   { printf '\033[1;31m::\033[0m %s\n' "$*" >&2; }
header()  { printf '\n\033[1;35m>>> %s\033[0m\n' "$*"; }

require() {
	for cmd in "$@"; do
		command -v "$cmd" &>/dev/null || { error "Required command not found: $cmd"; exit 1; }
	done
}

# --- Core operations ---

init_submodules() {
	local needs_init=false
	while IFS= read -r path; do
		[[ -e "$path/.git" ]] || needs_init=true
	done < <(git config --file .gitmodules --get-regexp 'submodule\..*\.path$' | awk '{print $2}')

	if [[ "$needs_init" == true ]]; then
		header "Initializing git submodules"
		git submodule update --checkout --init --jobs "$(nproc)" --depth 1
	fi
}

link_packages() {
	header "Linking packages: $*"
	stow --restow --verbose=1 --target "$HOME" --dir "$DOTFILES_DIR" "$@"
}

unlink_packages() {
	header "Unlinking packages: $*"
	stow -D --verbose=1 --target "$HOME" --dir "$DOTFILES_DIR" "$@"
}

# --- Bootstrap ---

bootstrap_zdotdir() {
	local target="$HOME/.zshenv"
	# shellcheck disable=SC2016
	local content='export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"'
	if [[ -f "$target" ]] && grep -qF 'ZDOTDIR' "$target"; then
		return 0
	fi
	header "Bootstrapping ZDOTDIR"
	echo "$content" > "$target"
	success "Created $target"
}

# --- Plugin installers ---

install_tmux_plugins() {
	header "Installing tmux plugins"
	"$DOTFILES_DIR/tmux/.config/tmux/plugins/tpm/bin/install_plugins"
}

install_zsh_plugins() {
	header "Installing zsh plugins"
	zsh -ic '@zinit-scheduler burst'
}

install_yazi_plugins() {
	header "Installing yazi plugins"
	ya pkg install
}

# --- Commands ---

cmd_install() {
	local scope="${1:-all}"
	init_submodules
	case "$scope" in
		term)
			require stow zsh tmux yazi nvim
			link_packages "${TERM_PACKAGES[@]}"
			bootstrap_zdotdir
			install_tmux_plugins
			install_zsh_plugins
			install_yazi_plugins
			;;
		desktop)
			require stow
			link_packages "${DESKTOP_PACKAGES[@]}"
			;;
		all)
			require stow zsh tmux yazi nvim
			link_packages "${ALL_PACKAGES[@]}"
			bootstrap_zdotdir
			install_tmux_plugins
			install_zsh_plugins
			install_yazi_plugins
			;;
		*) error "Unknown scope: $scope (use term, desktop, or all)"; exit 1 ;;
	esac
	success "Install complete"
	echo
	show_banner
}

cmd_update() {
	init_submodules
	if [[ -f "$HOME/.config/tmux/tmux.conf" ]]; then
		header "Updating tmux plugins"
		"$DOTFILES_DIR/tmux/.config/tmux/plugins/tpm/bin/update_plugins" all
	fi
	if [[ -d "$HOME/.config/zsh/zinit" ]]; then
		header "Updating zsh plugins"
		zsh -ic "zinit update --parallel; wait; zinit self-update"
	fi
	if [[ -d "$HOME/.config/nvim" ]]; then
		header "Updating neovim plugins"
		nvim --headless -c 'lua vim.pack.update()' -c 'sleep 10' -c 'qa!'
	fi
	if command -v ya &>/dev/null; then
		header "Updating yazi plugins"
		ya pkg upgrade
	fi
	success "Update complete"
}

cmd_unlink() {
	unlink_packages "${ALL_PACKAGES[@]}"
	success "All packages unlinked"
}

cmd_health() {
	local ok="\033[1;32m✓\033[0m" fail="\033[1;31m✗\033[0m" warn="\033[1;33m!\033[0m"
	check() {
	  if command -v "$1" >/dev/null 2>&1; then
		version=$({ "$1" --version 2>/dev/null || "$1" -V 2>/dev/null; } | head -n 1)
		printf " $ok %-12s %s\n" "$1" "$version"
	  else
		printf " $fail %-12s not found\n" "$1"
	  fi
	}

	header "Required tools"
	for cmd in zsh nvim tmux yazi stow git fzf rg; do check "$cmd"; done

	header "Environment"
	[[ "$SHELL" == */zsh ]]                  && printf " $ok login shell is zsh\n"         || printf " $fail login shell is not zsh ($SHELL)\n"
	[[ -n "${ZDOTDIR:-}" ]]                  && printf " $ok ZDOTDIR=$ZDOTDIR\n"           || printf " $warn ZDOTDIR is not set\n"
	[[ "$TERM" == *256color* || "$TERM" == *kitty* || "$TERM" == *alacritty* ]] \
	                                         && printf " $ok TERM=$TERM\n"                 || printf " $warn TERM=$TERM (may lack color support)\n"
	[[ "$(locale charmap 2>/dev/null)" == UTF-8 ]] \
	                                         && printf " $ok locale is UTF-8\n"            || printf " $warn locale is not UTF-8\n"
	[[ -n "$(git config user.name)" && -n "$(git config user.email)" ]] \
	                                         && printf " $ok git user configured\n"        || printf " $warn git user.name/email not set\n"

	header "Symlinks"
	local stow_ok=true
	for pkg in "${ALL_PACKAGES[@]}"; do
		[[ -d "$DOTFILES_DIR/$pkg" ]] || continue
		if stow --simulate --verbose "$pkg" 2>&1 | grep -q "LINK"; then
			printf " $fail %s has missing links\n" "$pkg"
			stow_ok=false
		fi
	done
	$stow_ok && printf " $ok all stow symlinks intact\n"

	header "Plugin managers"
	[[ -d "${ZDOTDIR:-$HOME/.config/zsh}/zinit" ]]      && printf " $ok zinit present\n"  || printf " $fail zinit not found\n"
	[[ -x "$DOTFILES_DIR/tmux/.config/tmux/plugins/tpm/tpm" ]] \
	                                                     && printf " $ok tpm present\n"    || printf " $fail tpm not found\n"

	header "Truecolor test (lines should be continuous)"
	bash "$DOTFILES_DIR/24-bit-color.sh"
	header "Clipboard test"
	zsh -ic "echo 123 | my-yank-to-clipboard"
}

show_banner() {
	printf '\033[1;35m'
	cat << 'EOF'
                             😈
  😈                                     😈                            😈
██████╗  █████╗ ███████╗███████╗██████╗     ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗
██╔══██╗██╔══██╗██╔════╝██╔════╝██╔══██╗    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝
██████╔╝███████║███████╗█████╗  ██║  ██║    ██║  😈 ██║██╔██╗ ██║██║   ██║ ╚███╔╝
██╔══██╗██╔══██║╚════██║██╔══╝  ██║  ██║    ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗
██████╔╝██║  ██║███████║███████╗██████╔╝    ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗
╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═════╝     ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝
                       😈              😈
 ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗                😈
██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
██║     ██║😈 ██║██╔██╗ ██║█████╗  ██║██║  ███╗      😈
██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║                         😈
╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
 ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝
                                                😈
😈██████╗ ███████╗██████╗ ██╗ 😈   ██████╗ ██╗   ██╗███████╗██████╗
  ██╔══██╗██╔════╝██╔══██╗██║     ██╔═══██╗╚██╗ ██╔╝██╔════╝██╔══██╗
  ██║  ██║█████╗  ██████╔╝██║     ██║   ██║ ╚████╔╝ █████╗  ██║  ██║
  ██║  ██║██╔══╝  ██╔═══╝ ██║     ██║   ██║  ╚██╔╝  ██╔══╝  ██║  ██║  😈
  ██████╔╝███████╗██║ 😈  ███████╗╚██████╔╝   ██║   ███████╗██████╔╝
  ╚═════╝ ╚══════╝╚═╝     ╚══════╝ ╚═════╝    ╚═╝   ╚══════╝╚═════╝
                                    😈                    😈
 █████╗ ███╗ 😈██╗██████╗     ██████╗ ███████╗ █████╗ ██████╗ ██╗   ██╗
██╔══██╗████╗  ██║██╔══██╗    ██╔══██╗██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝
███████║██╔██╗ ██║██║  ██║ 😈 ██████╔╝█████╗  ███████║██║  ██║ ╚████╔╝
██╔══██║██║╚██╗██║██║  ██║    ██╔══██╗██╔══╝  ██╔══██║██║  ██║  ╚██╔╝    😈
██║  ██║██║ ╚████║██████╔╝    ██║  ██║███████╗██║  ██║██████╔╝   ██║
╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝    ╚═╝
 😈                                                        😈
          😈
EOF
	printf '\033[0m'
}

usage() {
	cat <<-EOF
	Usage: $(basename "$0") <command>

	Commands:
	    install [term|desktop|all]  Link dotfiles and install plugins (default: all)
	    update                      Update all managed plugins
	    unlink                      Remove all symlinks from \$HOME
	    health                      Verify setup

	Options:
	    -h, --help                  Show this help
	EOF
}

# --- Main ---

case "${1:-}" in
	install)  shift; cmd_install "${1:-all}" ;;
	update)   cmd_update ;;
	unlink)   cmd_unlink ;;
	health)   cmd_health ;;
	-h|--help)
		usage
		;;
	*)
		usage
		exit 1
		;;
esac
