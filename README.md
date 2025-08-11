# Centralized Backup System — Secure backups with MinIO storage and Slack notifications


## Overview
A simple and reliable backup system that collects files from clients, compresses them, encrypts them using GPG, and uploads them to a MinIO server. Integrated with Slack notifications to alert on success or failure.

[IMAGE: architecture-diagram.png]

## Prerequisites
- Linux server for MinIO and Ansible
- Linux clients with `mc`, `gpg`, `tar`
- Ansible for deployment
- MinIO server credentials
- GPG key or passphrase
- Slack Bot Token and Channel ID

## Installation
1. Prepare Ansible variables and Vault with:
   - `gpg_passphrase`
   - `minio_access_key`
   - `minio_secret_key`
   - `slack_bot_token`
   - `slack_channel`
2. Run: ansible-playbook playbooks/install-tools.yml
3. Test MinIO alias: mc ls myminio && mc cp /etc/hosts myminio/backups/

## Running Backups
- Script: /usr/local/bin/backup.sh
- Manual: sudo /usr/local/bin/backup.sh
- Cron (2 AM daily): 0 2 * * * /usr/local/bin/backup.sh >> /var/log/backup.log 2>&1

## Restore Procedure
1. Download: mc cp myminio/backups/<file>.gpg .
2. Decrypt (interactive): gpg -o backup.tar.gz -d <file>.gpg
3. Extract: tar -xzvf backup.tar.gz

## Slack Notifications
Inside backup.sh:
send_slack() {
    curl -s -X POST -H 'Content-type: application/json' \
    --data "{\"channel\":\"$SLACK_CHANNEL\",\"text\":\"$1\"}" \
    https://slack.com/api/chat.postMessage \
    -H "Authorization: Bearer $SLACK_BOT_TOKEN" >/dev/null
}

## Security
- Restrict file permissions
- Avoid plain-text passphrases
- Enable log rotation
- Test restores regularly

## Troubleshooting
- Check MinIO connection: curl -v http://MINIO_IP:9000 && nc -vz MINIO_IP 9000
- Verify correct mc alias per user
- Check service: systemctl status minio && ss -tulpn | grep 9000
- Logs: cat /var/log/backup.log

[IMAGE: screenshot-example.png]

