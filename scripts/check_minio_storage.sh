#!/bin/bash

# Load environment variables from .env file next to this script
source "$(dirname "$0")/.env"

send_slack_message() {
  local message="$1"

  curl -s -X POST -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
       -H "Content-type: application/json" \
       --data "{\"channel\":\"$SLACK_CHANNEL\",\"text\":\"$message\"}" \
       https://slack.com/api/chat.postMessage > /dev/null
}

# Get current MinIO bucket size in bytes
BUCKET_SIZE_BYTES=$(mc du --json ${MINIO_ALIAS}/${MINIO_BUCKET} | jq '.totalSize')

# Convert bucket size to megabytes
BUCKET_SIZE_MB=$((BUCKET_SIZE_BYTES / 1024 / 1024))

echo "Current MinIO bucket size is: ${BUCKET_SIZE_MB} MB"

if [ "$BUCKET_SIZE_MB" -ge "$THRESHOLD_MB" ]; then
  send_slack_message "Warning: MinIO bucket '${MINIO_BUCKET}' size is ${BUCKET_SIZE_MB} MB which exceeds threshold of ${THRESHOLD_MB} MB."
fi

