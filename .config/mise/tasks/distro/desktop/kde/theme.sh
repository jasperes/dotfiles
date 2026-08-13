#!/usr/bin/env bash

#MISE description=""
#MISE hide=true
#MISE tools={ yq="latest" }

SETTINGS_TOML="${HOME}/.config/mise/resources/kde.toml"

[ ! -f "$SETTINGS_TOML" ] && echo "Erro: Arquivo $SETTINGS_TOML não encontrado." && exit 1

if command -v kwriteconfig6 &> /dev/null; then
    KCONFIG_BIN="kwriteconfig6"
elif command -v kwriteconfig5 &> /dev/null; then
    KCONFIG_BIN="kwriteconfig5"
else
    echo "Error: KDE configuration tools (kwriteconfig) not found."
    exit 1
fi

yq eval '.kde.theme | to_entries | .[] | .key + "|" + .value' "$SETTINGS_TOML" | while IFS='|' read -r config_path value; do
    [ -z "$config_path" ] && continue

    IFS=':' read -r file group key <<< "$config_path"
    
    echo "Theme: $config_path = $value"
    $KCONFIG_BIN --file "$file" --group "$group" --key "$key" "$value"
done

exit 0
