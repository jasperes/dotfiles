#!/usr/bin/env bash

#MISE description="Aplica a identidade visual completa do Dracula no KDE"
#MISE hide=true
#MISE tools={ yq="latest" }

SETTINGS_TOML="${HOME}/.config/mise/resources/kde.toml"

[ ! -f "$SETTINGS_TOML" ] && echo "Erro: Arquivo $SETTINGS_TOML não encontrado." && exit 1

if command -v kwriteconfig6 &> /dev/null; then
    KCONFIG_BIN="kwriteconfig6"
elif command -v kwriteconfig5 &> /dev/null; then
    KCONFIG_BIN="kwriteconfig5"
else
    echo "Erro: Ferramentas de configuração do KDE não encontradas."
    exit 1
fi

yq eval '.kde.theme | to_entries | .[] | .key + "|" + .value' "$SETTINGS_TOML" | while IFS='|' read -r config_path value; do
    [ -z "$config_path" ] && continue

    if [[ "$config_path" == kwriteconfig:* ]]; then
        IFS=':' read -r _ file group key <<< "$config_path"
        
        echo " -> Definindo: [$file] -> [$group] -> $key = $value"
        $KCONFIG_BIN --file "$file" --group "$group" --key "$key" "$value"
    fi
done

exit 0
