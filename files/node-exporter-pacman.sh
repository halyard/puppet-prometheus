#!/usr/bin/env bash

set -uo pipefail

pacman -Sy

updates="$(/usr/bin/pacman -Qu | wc -l)"
date="$(date '+%s')"

cat << EOF > /var/lib/node-exporter/pacman.prom.tmp
# HELP pacman_updates_pending number of pending updates from pacman
# TYPE pacman_updates_pending gauge
pacman_updates_pending $updates
# HELP pacman_update_check time of last update check"
# TYPE pacman_update_check gauge
pacman_update_check $date
EOF

mv /var/lib/node-exporter/pacman.prom.tmp /var/lib/node-exporter/pacman.prom

