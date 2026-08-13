#!/usr/bin/env bash

#MISE description=""
#MISE hide=true
#MISE tools={ yq="latest" }

set -e

SETTINGS_TOML="${HOME}/.config/mise/resources/core.toml"

[ ! -f "$SETTINGS_TOML" ] && echo "Error: File not found '$SETTINGS_TOML'" && exit 1

SHELL_BIN=$(yq eval '.core.shell.bin' "$SETTINGS_TOML")

SHELLS_FILE=/etc/shells

ZSH_FILE=/bin/zsh
if [[ -f $ZSH_FILE ]] && [[ -z $(grep $ZSH_FILE $SHELLS_FILE) ]]; then
    echo $ZSH_FILE | sudo tee -a $SHELLS_FILE
fi

TMUX_FILE=/bin/tmux
if [[ -f $TMUX_FILE ]] && [[ -z $(grep $TMUX_FILE $SHELLS_FILE) ]]; then
    echo $TMUX_FILE | sudo tee -a $SHELLS_FILE
fi

chsh -s $SHELL_BIN $USER

exit 0
