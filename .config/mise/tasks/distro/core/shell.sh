#!/usr/bin/env bash

#MISE description=""
#MISE hide=true
#USAGE flag "--"

set -e

SHELL_BIN="${usage_bin}"

# add shells
SHELLS_FILE=/etc/shells

## add zsh
ZSH_FILE=/bin/zsh
if [[ -f $ZSH_FILE ]] && [[ -z $(grep $ZSH_FILE $SHELLS_FILE) ]]; then
    echo $ZSH_FILE | sudo tee -a $SHELLS_FILE
fi

## add tmux
TMUX_FILE=/bin/tmux
if [[ -f $TMUX_FILE ]] && [[ -z $(grep $TMUX_FILE $SHELLS_FILE) ]]; then
    echo $TMUX_FILE | sudo tee -a $SHELLS_FILE
fi

# configure default shell
chsh -s $SHELL_BIN $USER
