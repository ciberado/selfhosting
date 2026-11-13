cd ~/services && find . -type f \( -name "docker-compose*.yml" -o -name ".env" \) -exec cp --parents {} "${BACKUP_DIR:?define BACKUP_DIR}"/  \;
