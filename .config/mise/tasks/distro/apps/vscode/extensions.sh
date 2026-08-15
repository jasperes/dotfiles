#!/usr/bin/env bash

#MISE description=""
#MISE hide=true
#MISE tools={ yq="latest" }

set -e

SETTINGS_TOML="${HOME}/.config/mise/resources/apps.toml"

[ ! -f "$SETTINGS_TOML" ] && echo "Error: File not found '$SETTINGS_TOML'" && exit 1

LIST_FILE=$(yq eval '.apps.vscode.extensions.file' "$SETTINGS_TOML")
LIST_FILE="${LIST_FILE/#\~/$HOME}"

[ ! -f "$LIST_FILE" ] && echo "Error: Extensions file not found '$LIST_FILE'" && exit 1

ARGS=$(grep -v -e '^#' -e '^$' "$LIST_FILE" | awk '{print "--install-extension", $1}' | tr '\n' ' ')

if [ -n "$ARGS" ]; then
    set +e
    code $ARGS 2>&1 | grep -v -E "Installing extensions...|already installed|DeprecationWarning|\[DEP|Use \`electron"
    set -e
fi

exit 0
