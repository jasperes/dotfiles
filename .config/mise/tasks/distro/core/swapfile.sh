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

# Check variables
[[ -z "$SWAP_FILE" || "$SWAP_FILE" == "null" ]] && echo "Error: Swap file path not defined in TOML" && exit 1
[[ -z "$SWAP_SIZE" || "$SWAP_SIZE" == "null" ]] && echo "Error: Swap size not defined in TOML" && exit 1

# target directory to check filesystem type
TARGET_DIR=$(dirname "$SWAP_FILE")
FS_TYPE=$(df -T "$TARGET_DIR" | awk 'NR==2 {print $2}')

# check if swapfile exists and matches requested size
CURRENT_SIZE=$(
    swapon --show=NAME,SIZE --bytes --noheadings | \
    awk -v path="$SWAP_FILE" '$1 == path {print int(($2 / 1024 / 1024) + 0.5); found=1} END {if (!found) print 0}')

# swapfile already ok
if [[ -f "$SWAP_FILE" ]] && [[ "$CURRENT_SIZE" -eq "$SWAP_SIZE" ]]; then
    echo "swapfile already created and active at $SWAP_FILE with size $SWAP_SIZE"
    exit 0
fi

# create or modify file
if [[ "$CURRENT_SIZE" -ne "$SWAP_SIZE" ]]; then
    # delete current swapfile safely
    if [[ -f "$SWAP_FILE" ]]; then
        echo "Removing current swapfile"
        sudo swapoff "$SWAP_FILE" || true
        sudo rm -f "$SWAP_FILE"
    fi

    # conditional creation based on filesystem
    if [[ "$FS_TYPE" == "btrfs" ]]; then
        # btrfs
        echo "Creating btrfs swap at $SWAP_FILE with size $SWAP_SIZE"
        sudo btrfs filesystem mkswapfile --size "${SWAP_SIZE}M" "$SWAP_FILE"
    else
        # fallback dd way for ext4/xfs
        echo "Creating ext4 swap at $SWAP_FILE with size $SWAP_SIZE"
        sudo dd if=/dev/zero of="$SWAP_FILE" bs=1M count="$SWAP_SIZE" status=progress
    fi
fi

# setup swap permissions and activate
if [[ -z $(swapon --show=NAME --noheadings | grep -x "$SWAP_FILE") ]]; then
    echo "Activate swapfile"
    sudo chmod 600 "$SWAP_FILE"
    sudo mkswap "$SWAP_FILE"
    sudo swapon -p 10 "$SWAP_FILE"
fi

# persist swap in fstab
SWAP_CONFIG="$SWAP_FILE swap swap defaults,pri=10 0 0"
FSTAB=/etc/fstab
if [[ -z $(grep -F "$SWAP_FILE" "$FSTAB") ]]; then
    echo "Adding swapfile to fstab"
    echo "$SWAP_CONFIG" | sudo tee -a $FSTAB
fi

exit 0
