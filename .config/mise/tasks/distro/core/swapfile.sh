#!/usr/bin/env bash

#MISE description=""
#MISE hide=true
#MISE tools={ yq="latest" }

set -e

SETTINGS_TOML="${HOME}/.config/mise/resources/core.toml"

[ ! -f "$SETTINGS_TOML" ] && echo "Error: File not found '$SETTINGS_TOML'" && exit 1

# Extrai as configurações de swap a partir do arquivo TOML
SWAP_FILE=$(yq eval '.core.swap.file' "$SETTINGS_TOML")
SWAP_SIZE=$(yq eval '.core.swap.size' "$SETTINGS_TOML")

# target directory to check filesystem type
TARGET_DIR=$(dirname "$SWAP_FILE")
FS_TYPE=$(df -T "$TARGET_DIR" | awk 'NR==2 {print $2}')

# check if swapfile exists and matches requested size
CURRENT_SIZE=$(sudo wc -c "$SWAP_FILE" | awk '{print $1}' || echo '0')
EXPECTED_SIZE=$((SWAP_SIZE * 1000000))

if [[ "$CURRENT_SIZE" != "$EXPECTED_SIZE" ]]; then
    # delete current swapfile safely
    if [[ -f "$SWAP_FILE" ]]; then
        sudo swapoff "$SWAP_FILE" || true
        sudo rm -f "$SWAP_FILE"
    fi

    # conditional creation based on filesystem
    if [[ "$FS_TYPE" == "btrfs" ]]; then
        # btrfs
        sudo btrfs filesystem mkswapfile --size "${SWAP_SIZE}m" "$SWAP_FILE"
    else
        # fallback dd way for ext4/xfs
        sudo dd if=/dev/zero of="$SWAP_FILE" bs=1MB count="$SWAP_SIZE" status=progress
    fi
fi

# setup swap permissions and activate
if [[ -z $(swapon --show | grep "$SWAP_FILE file") ]]; then
    sudo chmod 600 "$SWAP_FILE"
    sudo mkswap "$SWAP_FILE"
    sudo swapon -p 10 "$SWAP_FILE"
fi

# persist swap in fstab
SWAP_CONFIG="$SWAP_FILE swap swap defaults,pri=10 0 0"
FSTAB=/etc/fstab
if [[ -z $(grep -F "$SWAP_FILE" "$FSTAB") ]]; then
    echo "$SWAP_CONFIG" | sudo tee -a $FSTAB
fi

exit 0
