if (( ${+commands[pacman]} )); then
	alias pu='sudo pacman -Syu'
	alias pa="my-packages-install"
	alias pA="sudo pacman -S"
	alias prm="sudo pacman -Rns"
	alias pls="my-packages-list"
	alias plsa="pacman -Q"
	alias pse="pacman -F"
	alias pown="pacman -Qo"

	alias ya="yay --aur -Sl | fzf --multi --preview-window=wrap --preview 'cat <(yay -Si {2})' | cut -d' ' -f2 | xargs -ro yay -S"
	alias yA="yay -S"
	alias yau="yay --sudoloop -Su"
fi