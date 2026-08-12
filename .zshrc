# ======================== COMPLETIONS ======================== #

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# ======================== IMPORTS ======================== #

source ~/.shrc
# for x in $(ls ~/ -a | grep '.zshrc.'); do source "$x"; done

# ======================== OH MY ZSH ======================== #

export ZSH="$HOME/.oh-my-zsh"
plugins=(
  git
  colorize
  zsh-mise
  zsh-completions
  zsh-history-substring-search
  zsh-autosuggestions
  zsh-autocomplete
  zsh-syntax-highlighting
)
fpath+=~/.oh-my-zsh/custom/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ======================== CONFIG ======================== #

# Turn off all beeps
unsetopt BEEP
# Turn off autocomplete beeps
unsetopt LIST_BEEP

# Ignore duplicated shell history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
