#!/usr/bin/env bash

set -euo pipefail

updates="$(/usr/bin/checkupdates | wc -l)"

cat << EOF > /var/lib/node-exporter/pacman.prom.tmp
# HELP updates_pending number of pending updates from pacman
# TYPE updates_pending gauge
pacman_updates_pending $updates
EOF

mv /var/lib/node-exporter/pacman.prom.tmp /var/lib/node-exporter/pacman.prom

