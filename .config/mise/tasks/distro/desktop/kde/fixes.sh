#!/usr/bin/env bash

#MISE description=""
#MISE hide=true

set -e

# https://www.reddit.com/r/cachyos/comments/1ufa5jz/plasma_login_manager_not_applying/
if [[ "$(stat -c '%U' /var/lib/plasmalogin/)" -ne "plasmalogin" ]]; then
    echo "Fix plasma login owner"
    sudo find /var/lib/plasmalogin/ -type d -exec chmod +x {} +
    sudo chown -R plasmalogin:plasmalogin /var/lib/plasmalogin/
fi

exit 0
