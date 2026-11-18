groups@Groups:/opt/ccm101-cloud$ sudo cat auto-backup.sh
#!/usr/bin/env bash
set -Eeuo pipefail
umask 077
PROJECT_DIR="/opt/ccm101-cloud"
BACKUP_DIR="$PROJECT_DIR/backups" TIMESTAMP=$(date +"%Y-%m-%d_%H%M-%S") BACKUP_FILE="$BACKUP_DIR/wordpress-$TIMESTAMP.sql.gz" TEMP_FILE="$BACKUP_DIR/.wordpress-$TIMESTAMP.tmp"
LOG_FILE="$BACKUP_DIR/backup.log"
mkdir -p "$BACKUP_DIR" cd "$PROJECT_DIR"
-cleanup() {
rm -f "$TEMP_FILE" }
trap cleanup EXIT
Log() {
}
echo "[$(date +%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
log "Starting MariaDB backup..."
if docker compose exec -T db sh -c \ 'exec mariadb-dump -u root -p"$MARIADB_ROOT_PASSWORD" -single-transaction -routines -triggers "$MARIADB_DATABASE" \ | gzip > "$TEMP_FILE"; then failed."
fi
log "ERROR: Database dump exit 1
if [[ ! -s "$TEMP_FILE" ]] || ! gzip -t "$TEMP_FILE"; then Log "ERROR: Backup is empty or corrupted."
exit 1
fi
mv "$TEMP_FILE" "$BACKUP_FILE"
chmod 600 "$BACKUP_FILE"
Log "SUCCESS: Backup created: $BACKUP_FILE"
#Retain backups for seven days.
find "$BACKUP_DIR" -maxdepth 1 -type f \ -name 'wordpress-*.sql.gz -mtime +7 -delete
Log "Backup process completed."
group5@Group5:/opt/ccm101-cloud$
