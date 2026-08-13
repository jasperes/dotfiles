# if running bash
if [ -n "$BASH_VERSION" ]; then
    [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# if running zsh
elif [ -n "$ZSH_VERSION" ]; then
    [ -f "$HOME/.zshrc" ] && . "$HOME/.zshrc"

# if no shell found
else
    [ -f "$HOME/.shrc" ] && . "$HOME/.shrc"
fi
