#!/usr/bin/env bash
set -euo pipefail

TARGET_HOST="$1"
MAX_SECONDS="${2:-600}"

end_time=$(( $(date +%s) + MAX_SECONDS ))

## Ping until target is offline
while true; do
    if ! ping -c1 -W2 "$TARGET_HOST" >/dev/null 2>&1; then
        ## Host is unreachable
        echo "Host $TARGET_HOST is offline."

        exit 0
    fi

    now=$(date +%s)
    if (( now >= end_time )); then
        echo "Timeout: host $TARGET_HOST is still responding, retrying in 10 seconds"
        exit 1
    fi

    sleep 10
done
