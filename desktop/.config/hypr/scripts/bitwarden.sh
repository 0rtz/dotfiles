#!/bin/bash

set -euo pipefail

WORKSPACE="special:bitwarden"

if hyprctl clients -j | jq -e ".[] | select(.workspace.name == \"${WORKSPACE}\")" >/dev/null; then
    # Workspace is not empty
    hyprctl dispatch togglespecialworkspace bitwarden
else
    bitwarden-desktop
fi
