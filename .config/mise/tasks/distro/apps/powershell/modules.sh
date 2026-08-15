#!/usr/bin/env bash

#MISE description=""
#MISE hide=true
#MISE tools={ yq="latest" }

set -e

SETTINGS_TOML="${HOME}/.config/mise/resources/apps.toml"

[ ! -f "$SETTINGS_TOML" ] && echo "Error: File not found '$SETTINGS_TOML'" && exit 1

yq eval '.apps.powershell.modules[]' "$SETTINGS_TOML" | while read -r mod_id || [[ -n "$mod_id" ]]; do
    [ -z "$mod_id" ] && continue

    echo "Module: $mod_id"
    pwsh -Command "Install-Module -Name $mod_id -Repository PSGallery -Force"
done

exit 0
