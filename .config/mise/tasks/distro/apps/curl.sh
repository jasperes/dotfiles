#!/usr/bin/env bash

#MISE description=""
#MISE hide=true
#MISE tools={ yq="latest" }

set -e

SETTINGS_TOML="${HOME}/.config/mise/resources/apps.toml"

[ ! -f "$SETTINGS_TOML" ] && echo "Error: File not found '$SETTINGS_TOML'" && exit 1

yq eval '.apps.curl | to_entries[] | [.key, .value.link, .value.shell, (.value.args // "")] | @tsv' "${SETTINGS_TOML}" | while IFS=$'\t' read -r name link shell args; do
    [[ -z "$name" ]] && continue

    echo "Installing ${name} from ${shell}..."
    curl -fsSL "$link" | $shell -s -- "" $args && echo "...Success!" || echo "...Failure!"
    echo
done

exit 0
