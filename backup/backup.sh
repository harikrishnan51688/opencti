#!/bin/bash
set -euo pipefail

BACKUP_DIR="/opt/backups/opencti/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Volume name may change.
# also map with restore file. :)
VOLUMES=(
  "opencti-vwsghv_amqpdata"
  "opencti-vwsghv_esdata"
  "opencti-vwsghv_redisdata"
  "opencti-vwsghv_rsakeys"
  "opencti-vwsghv_s3data"
)

for VOL in "${VOLUMES[@]}"; do
  echo ">> Backing up $VOL"
  docker run --rm \
    -v "${VOL}:/data:ro" \
    -v "${BACKUP_DIR}:/backup" \
    alpine \
    tar czf "/backup/${VOL}.tar.gz" -C /data .
done

echo "Backup complete: $BACKUP_DIR"
