### direnv: load and unload environment variables from .envrc file depending on the current directory
# https://github.com/romkatv/powerlevel10k#how-do-i-initialize-direnv-when-using-instant-prompt
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### load and unload environment variables from .envrc file depending on the current directory
# https://github.com/direnv/direnv
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

# my dotfiles
# NOTE: might have problems when reordering
[ -f $HOME/.zsh/configs.zsh ]    && source $HOME/.zsh/configs.zsh
[ -f $HOME/.zsh/plugins.zsh ]    && source $HOME/.zsh/plugins.zsh
[ -d $HOME/.zsh/functions ]      && for f in $HOME/.zsh/functions/*.zsh; do source $f; done
[ -d $HOME/.zsh/aliases ]        && for f in $HOME/.zsh/aliases/*.zsh; do source $f; done
[ -f $HOME/.zsh/keymaps.zsh ]    && source $HOME/.zsh/keymaps.zsh

# To update prompt, run 'p10k configure' or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
