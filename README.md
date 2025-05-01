
# My linux dotfiles ⌨

![desktop](img)

*Includes configuration files for*:
| **Window manager**       | **[sway](https://github.com/swaywm/sway), [hyprland](https://github.com/hyprwm/Hyprland)**              |
|:-------------------------|:--------------------------------------------------------|
| **Status bar**           | **[waybar](https://github.com/Alexays/Waybar)**         |
| **Application launcher** | **[wofi](https://hg.sr.ht/~scoopta/wofi)**              |
| **Notification daemon**  | **[dunst](https://github.com/dunst-project/dunst)**     |
| **Terminal**             | **[alacritty](https://github.com/alacritty/alacritty)** |
| **File manager**         | **[nnn](https://github.com/jarun/nnn)**                 |
| **Editor**               | **[neovim](https://github.com/neovim/neovim)**          |
| **Terminal multiplexer** | **[tmux](https://github.com/tmux/tmux.git)**            |
| **Shell**                | **[zsh](https://github.com/zsh-users/zsh.git)**         |

*Deploybale to \$HOME with GNU Stow*:

```bash
# link configuration files for cli programs
./install.sh --term
# link configuration files for programs available in desktop environment
./install.sh --desktop
```
