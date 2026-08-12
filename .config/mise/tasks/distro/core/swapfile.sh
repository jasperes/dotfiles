#!/usr/bin/env bash

set -e

SWAP_FILE="${usage_file}"
SWAP_SIZE="${usage_size}"

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
