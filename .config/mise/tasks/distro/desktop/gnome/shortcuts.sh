#!/usr/bin/env bash

#MISE description=""
#MISE hide=true
#MISE tools={ yq="latest" }

set -e

SETTINGS_TOML="${HOME}/.config/mise/resources/gnome.toml"

shortcuts_data=$(yq '.gnome.shortcuts | to_entries | .[] | [.key, .value.binding, .value.command] | @tsv' "${SETTINGS_TOML}")

n=0
GSET_ARRAY=""
while IFS=$'\t' read -r name binding command; do
    [[ -z "$name" ]] && continue
    [[ "$n" != "0" ]] && GSET_ARRAY="${GSET_ARRAY},"
    GSET_ARRAY="${GSET_ARRAY}'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${n}/'"
    n=$((n+1))
done <<< "$shortcuts_data"

echo gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[$GSET_ARRAY]"

n=0
while IFS=$'\t' read -r name binding command; do
    [[ -z "$name" ]] && continue
    echo "Configuring: name='$name' | command='$command' | binding='$binding'"
    echo gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${n}/ binding "$binding"
    echo gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${n}/ command "$command"
    echo gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${n}/ name "$name"
    n=$((n+1))
done <<< "$shortcuts_data"

exit 0
