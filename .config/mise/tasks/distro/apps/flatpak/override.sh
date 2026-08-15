#!/usr/bin/env bash

#MISE description=""
#MISE hide=true
#MISE tools={ yq="latest" }

set -e

SETTINGS_TOML="${HOME}/.config/mise/resources/apps.toml"

[ ! -f "$SETTINGS_TOML" ] && echo "Error: File not found '$SETTINGS_TOML'" && exit 1

yq eval '.apps.flatpak.override[] | [.option, .value, (.app // "")] | @tsv' "${SETTINGS_TOML}" | while IFS=$'\t' read -r option value app; do
    [[ -z "$option" || -z "$value" ]] && continue

    echo "Override ${option}=${value} ${app}..."
    flatpak override --user --$option=$value $app
done

exit 0
