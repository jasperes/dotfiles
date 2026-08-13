# ======================== DRACULA ======================== #
# zfz
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

# man-page
export MANPAGER="/usr/bin/less -s -M +Gg" #standard linux
#export MANPAGER="/opt/homebrew/bin/less -s -M +Gg" #M1 macOS

#man-page colors
export LESS_TERMCAP_mb=$'\e[1;31m'      # begin bold
export LESS_TERMCAP_md=$'\e[1;34m'      # begin blink
export LESS_TERMCAP_so=$'\e[01;45;37m'  # begin reverse video
export LESS_TERMCAP_us=$'\e[01;36m'     # begin underline
export LESS_TERMCAP_me=$'\e[0m'         # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'         # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'         # reset underline
export GROFF_NO_SGR=1                   # for konsole

# zsh theme
export DRACULA_DISPLAY_GIT=1
export DRACULA_DISPLAY_TIME=1
export DRACULA_DISPLAY_CONTEXT=0
export DRACULA_DISPLAY_FULL_CWD=0
export DRACULA_DIR_TRIM=0
export DRACULA_DISPLAY_NEW_LINE=1
#export DRACULA_TIME_FORMAT="%-H:%M"
#export DRACULA_ARROW_ICON="-> "
#export DRACULA_CUSTOM_VARIABLE=""

# oh-my-zsh
ZSH_THEME="dracula"

# zsh-syntax-highlighting
source ~/.dracula.zsh-syntax-highlighting.sh

# zsh colorized
export ZSH_COLORIZE_STYLE="dracula"
export ZSH_COLORIZE_CHROMA_FORMATTER=terminal256
