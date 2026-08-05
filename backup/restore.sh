#!/bin/bash
set -euo pipefail

BACKUP_DIR="/opt/backups/opencti/20260805_120334"

declare -A VOLUME_MAP=(
  ["opencti-vwsghv_amqpdata"]="opencti_amqpdata"
  ["opencti-vwsghv_esdata"]="opencti_esdata"
  ["opencti-vwsghv_redisdata"]="opencti_redisdata"
  ["opencti-vwsghv_rsakeys"]="opencti_rsakeys"
  ["opencti-vwsghv_s3data"]="opencti_s3data"
)

for OLD_VOL in "${!VOLUME_MAP[@]}"; do
  NEW_VOL="${VOLUME_MAP[$OLD_VOL]}"
  echo ">> Restoring $OLD_VOL -> $NEW_VOL"
  docker volume create "$NEW_VOL" >/dev/null
  docker run --rm \
    -v "${NEW_VOL}:/data" \
    -v "${BACKUP_DIR}:/backup" \
    alpine \
    sh -c "rm -rf /data/* && tar xzf /backup/${OLD_VOL}.tar.gz -C /data"
done
