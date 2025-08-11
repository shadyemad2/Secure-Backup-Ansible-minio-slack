# Centralized Backup System — Secure backups with MinIO storage and Slack notifications

## Overview
A simple and reliable backup system that collects files from clients, compresses them, encrypts them using GPG, and uploads them to a MinIO server. Integrated with Slack notifications to alert on success or failure.

<img width="2816" height="1536" alt="Gemini_Generated_Image_h3vrdqh3vrdqh3vr" src="https://github.com/user-attachments/assets/9842b875-3f21-4164-bf6a-f747b1e2b162" />


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

<img width="674" height="361" alt="install minio" src="https://github.com/user-attachments/assets/1bc2ce8a-97a9-4ae7-b2fc-02efcc284f44" />


## Running Backups
- Script: /usr/local/bin/backup.sh
- Manual: sudo /usr/local/bin/backup.sh
- Cron (2 AM daily): 0 2 * * * /usr/local/bin/backup.sh >> /var/log/backup.log 2>&1

<img width="1869" height="832" alt="playbook-test" src="https://github.com/user-attachments/assets/529a36e9-8926-436a-b26f-5d12f1411f90" />


## Restore Procedure
1. Download: mc cp myminio/backups/<file>.gpg .
2. Decrypt (interactive): gpg -o backup.tar.gz -d <file>.gpg
3. Extract: tar -xzvf backup.tar.gz

<img width="1015" height="302" alt="upload-backup-from-minio" src="https://github.com/user-attachments/assets/9c17e4ef-f521-4814-95d2-f90ee0b081e3" />


## Slack Notifications
Inside backup.sh:
send_slack() {
    curl -s -X POST -H 'Content-type: application/json' \
    --data "{\"channel\":\"$SLACK_CHANNEL\",\"text\":\"$1\"}" \
    https://slack.com/api/chat.postMessage \
    -H "Authorization: Bearer $SLACK_BOT_TOKEN" >/dev/null
}

<img width="1837" height="921" alt="messages-to-slack" src="https://github.com/user-attachments/assets/d3e8ed13-3556-42f3-8592-e32a8ee92e81" />

## Security
- Restrict file permissions
- Avoid plain-text passphrases
- Enable log rotation
- Test restores regularly

<img width="1860" height="886" alt="gpg-pass" src="https://github.com/user-attachments/assets/5f1bde53-d73a-4a39-9e08-e76df340537b" />


## Troubleshooting
- Check MinIO connection: curl -v http://MINIO_IP:9000 && nc -vz MINIO_IP 9000
- Verify correct mc alias per user
- Check service: systemctl status minio && ss -tulpn | grep 9000
- Logs: cat /var/log/backup.log

---

## 🙌 Author

**Shady Emad Wahib Farhat**

DevOps | Linux | Kubernetes | Cloud Enthusiast  
[LinkedIn Profile](https://www.linkedin.com/in/shadyemad)  
[GitHub Profile](https://github.com/shadyemad)

---


