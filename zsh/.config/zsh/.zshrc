########################################
# 'romkatv/powerlevel10k' prompt

# direnv: must be before p10k instant prompt
# https://github.com/romkatv/powerlevel10k#how-do-i-initialize-direnv-when-using-instant-prompt
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt (must be near top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# direnv hook (after instant prompt)
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

########################################
# ZSH configuration

ZSHDIR="${ZDOTDIR:-$HOME/.config/zsh}"

# Using direct sourcing to avoid function scoping issues with typeset
for file in "$ZSHDIR"/env/*.zsh(N); do source "$file"; done
for file in "$ZSHDIR"/options/*.zsh(N); do source "$file"; done
for file in "$ZSHDIR"/functions/**/*.zsh(N); do source "$file"; done
for file in "$ZSHDIR"/plugins/*.zsh(N); do source "$file"; done
for file in "$ZSHDIR"/keymaps/*.zsh(N); do source "$file"; done
for file in "$ZSHDIR"/aliases/*.zsh(N); do source "$file"; done
for file in "$ZSHDIR"/prompt/*.zsh(N); do source "$file"; done

# Machine-specific overrides
[[ -f "$ZSHDIR/.zshrc.local" ]] && source "$ZSHDIR/.zshrc.local" || true