#!/usr/bin/env bash

#MISE description=""
#MISE hide=true
#MISE tools={ yq="latest" }

set -e

SETTINGS_TOML="${HOME}/.config/mise/resources/gnome.toml"

[ ! -f "$SETTINGS_TOML" ] && echo "Error: File not found '$SETTINGS_TOML'" && exit 1

yq eval '.gnome.settings | to_entries | .[] | .key + "|" + .value' "$SETTINGS_TOML" | while IFS='|' read -r path_key value; do
    [ -z "$path_key" ] && continue

    echo "Set: $path_key = $value"
    gsettings set $path_key "$value"
done

exit 0
