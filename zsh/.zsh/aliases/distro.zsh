if command -v pacman > /dev/null; then
	alias pacup='sudo pacman -Syu'
	alias pacin="my-packages-install"
	alias pacinstall="sudo pacman -S"
	alias pacrm="sudo pacman -Rns"
	alias pacse="pacman -F"
	alias pacown="pacman -Qo"
	alias pacls="my-packages-list"
	alias paclsa="pacman -Q"
	alias pacdeps="pactree"
	alias pacdepsr="pactree -r"
	alias yain="yay --aur -Sl | fzf --multi --preview-window=wrap --preview 'cat <(yay -Si {2})' | cut -d' ' -f2 | xargs -ro yay -S"
	alias yainstall="yay -S"
fi
