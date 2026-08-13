#!/usr/bin/env bash

#MISE description=""
#MISE hide=true
#MISE tools={ yq="latest" }

set -e

SETTINGS_TOML="${HOME}/.config/mise/resources/gnome.toml"

[ ! -f "$SETTINGS_TOML" ] && echo "Error: File not found '$SETTINGS_TOML'" && exit 1

yq eval '.gnome.extensions[]' "$SETTINGS_TOML" | while read -r ext_id || [[ -n "$ext_id" ]]; do
    [ -z "$ext_id" ] && continue

    echo "Extension: $ext_id"
    busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s "${ext_id}" &> /dev/null || true
done

exit 0
