#!/usr/bin/env bash

#MISE description=""
#MISE hide=true
#MISE tools={ yq="latest" }

SETTINGS_TOML="${HOME}/.config/mise/resources/kde.toml"

[ ! -f "$SETTINGS_TOML" ] && echo "Error: File not found '$SETTINGS_TOML'" && exit 1

if command -v kwriteconfig6 &> /dev/null; then
    KCONFIG_BIN="kwriteconfig6"
elif command -v kwriteconfig5 &> /dev/null; then
    KCONFIG_BIN="kwriteconfig5"
else
    echo "Error: KDE configuration tools (kwriteconfig) not found."
    exit 1
fi

yq eval '.kde.shortcuts | keys | .[]' "$SETTINGS_TOML" | while read -r desktop_key || [[ -n "$desktop_key" ]]; do
    [ -z "$desktop_key" ] && continue

    binding=$(yq eval ".kde.shortcuts.\"$desktop_key\".binding" "$SETTINGS_TOML")
    group=$(yq eval ".kde.shortcuts.\"$desktop_key\".group" "$SETTINGS_TOML")

    echo "Shortcut: key='$desktop_key' | group='$group' | binding='$binding'"
    $KCONFIG_BIN --file ~/.config/kglobalshortcutsrc --group "$group" --group "$desktop_key" --key "_launch" "$binding"
done

exit 0
