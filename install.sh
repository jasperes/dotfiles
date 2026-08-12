#!/usr/bin/env bash

set -e

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

[[ -f .env ]] && source .env

mkdir -p "${HOME}/.config/mise/"
mkdir -p "${HOME}/.config/mise/conf.d/"

# ln -s "${current_dir}/dotfiles" "${HOME}/.dotfiles" || true
ln -sf "${HOME}/.dotfiles/.config/mise/config.toml" "${HOME}/.config/mise/config.toml" || true
ln -sf "${HOME}/.dotfiles/.config/mise/conf.d/${SYSTEM}.toml" "${HOME}/.config/mise/conf.d/system.toml" || true
ln -sf "${HOME}/.dotfiles/.config/mise/conf.d/${THEME}.toml" "${HOME}/.config/mise/conf.d/theme.toml" || true

curl https://mise.run | sh
eval "$(mise activate bash)"
mise bootstrap --force-dotfiles

echo "All done. Restart system!" && exit 0
