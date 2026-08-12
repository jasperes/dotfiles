#!/usr/bin/env bash

#MISE description=""
#MISE hide=true
#MISE tools={ yq="latest" }

SETTINGS_TOML="${HOME}/.config/mise/resources/gnome.toml"

[ ! -f "$SETTINGS_TOML" ] && echo "Erro: Arquivo $SETTINGS_TOML não encontrado." && exit 1

yq eval '.gnome.settings | to_entries | .[] | .key + "|" + .value' "$SETTINGS_TOML" | while IFS='|' read -r path_key value; do
    [ -z "$path_key" ] && continue
    echo "Aplicando: gsettings set $path_key '$value'"
    echo gsettings set $path_key "$value"
done

exit 0
