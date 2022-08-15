#!/usr/bin/env bash

set -euo pipefail

lastline="$(grep -h 'Notice: Applied catalog' /opt/halyard/logs/puppet-run.* | sort | tail -1)"
lastdatetime="$(echo "$lastline" | awk '{print $1, $2}')"
lastapplyspeed="$(echo "$lastline" | awk '{print $7}')"
lastepoch="$(date -d "$lastdatetime" '+%s')"


cat << EOF > /var/lib/node-exporter/puppet.prom.tmp
# HELP puppet_apply_speed time taken for last puppet apply
# TYPE puppet_apply_speed gauge
puppet_apply_speed $lastapplyspeed
# HELP puppet_last_run time of last successful puppet run"
# TYPE puppet_last_run gauge
puppet_last_run $lastepoch
EOF

mv /var/lib/node-exporter/puppet.prom.tmp /var/lib/node-exporter/puppet.prom

