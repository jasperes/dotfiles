#!/usr/bin/env bash

set -e

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

[[ -f .env ]] && source .env

mkdir -p "${HOME}/.config/mise/"
mkdir -p "${HOME}/.config/mise/conf.d/"

ln -s "${current_dir}/dotfiles" "${HOME}/.dotfiles" || true
ln -s "${current_dir}/profiles/config.toml" "${HOME}/.config/mise/config.toml" || true
ln -s "${current_dir}/profiles/conf.d/${SYSTEM}.toml" "${HOME}/.config/mise/conf.d/system.toml" || true
ln -s "${current_dir}/profiles/conf.d/${THEME}.toml" "${HOME}/.config/mise/conf.d/theme.toml" || true

curl https://mise.run | sh
mise bootstrap --force-dotfiles

echo "All done. Restart system!" && exit 0
