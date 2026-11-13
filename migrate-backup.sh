#!/usr/bin/env bash
# Backup completo previo a la migración WSL2 -> Fedora.
# Uso: sudo -E env HOME_USER=javi bash migrate-backup.sh [/mnt/f/migration-backup]
# Fases: 1) dumps de BD en caliente  2) parar stacks  3) tar de ~/services y home
#        4) tar de volúmenes Docker  5) metadatos  6) checksums  7) (opcional) arrancar de nuevo
set -uo pipefail

USER_NAME="${HOME_USER:-javi}"
USER_HOME="/home/$USER_NAME"
SERVICES="$USER_HOME/services"
DEST="${1:-/mnt/f/migration-backup}/$(date +%F)"
LOG="$DEST/backup.log"

[ "$EUID" -eq 0 ] || { echo "Ejecuta con sudo"; exit 1; }
mountpoint -q "$(dirname "$DEST")" 2>/dev/null || [ -d "$(dirname "$DEST")" ] || mkdir -p "$(dirname "$DEST")"
mkdir -p "$DEST"/{dumps,volumes,meta}
exec > >(tee -a "$LOG") 2>&1

if command -v zstd >/dev/null; then COMP="zstd -T0 -3"; EXT="tar.zst"; elif command -v pigz >/dev/null; then COMP="pigz -3"; EXT="tar.gz"
else COMP="gzip -3"; EXT="tar.gz"; fi
log() { echo "[$(date +%T)] $*"; }
fail=0

# ---------- 1. Dumps en caliente ----------
log "Fase 1: dumps de bases de datos"
for c in $(docker ps --format '{{.Names}}'); do
  img=$(docker inspect -f '{{.Config.Image}}' "$c")
  case "$img" in
    *postgres*|*pgvector*)
      log "pg_dumpall $c"
      docker exec "$c" sh -c 'pg_dumpall -U "${POSTGRES_USER:-postgres}"' 2>>"$LOG" | gzip > "$DEST/dumps/$c.sql.gz" \
        || { log "ERROR dump $c"; fail=1; } ;;
    *mariadb*|*mysql*)
      log "mysqldump $c"
      docker exec "$c" sh -c 'D=$(command -v mariadb-dump || command -v mysqldump); $D -uroot -p"$MYSQL_ROOT_PASSWORD" --all-databases --single-transaction' 2>>"$LOG" | gzip > "$DEST/dumps/$c.sql.gz" \
        || { log "ERROR dump $c"; fail=1; } ;;
  esac
done

# ---------- 2. Metadatos (antes de parar) ----------
log "Fase 2: metadatos"
docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}' > "$DEST/meta/containers.txt"
docker images --digests > "$DEST/meta/images-digests.txt"
docker volume ls -q > "$DEST/meta/volumes.txt"
docker compose ls -a > "$DEST/meta/compose-projects.txt" 2>&1
sudo -u "$USER_NAME" crontab -l > "$DEST/meta/crontab.txt" 2>&1
cp /etc/fstab /etc/wsl.conf /etc/hosts "$DEST/meta/" 2>/dev/null
systemctl list-unit-files --state=enabled --no-pager > "$DEST/meta/enabled-units.txt" 2>&1
docker info > "$DEST/meta/docker-info.txt" 2>&1
tailscale status > "$DEST/meta/tailscale-host.txt" 2>&1 || true

# ---------- 3. Parar stacks ----------
log "Fase 3: parando stacks"
for d in "$SERVICES"/*/; do
  if [ -f "$d/docker-compose.yml" ] || [ -f "$d/docker-compose.yaml" ]; then
    log "down $(basename "$d")"
    (cd "$d" && sudo -u "$USER_NAME" docker compose down) >>"$LOG" 2>&1
  fi
done
# contenedores sueltos
docker ps -q | xargs -r docker stop >>"$LOG" 2>&1

# ---------- 4. tar de services y home ----------
log "Fase 4: tar de ~/services (preserva owners/permisos)"
tar --numeric-owner --xattrs --acls -cpf - -C "$USER_HOME" services | $COMP > "$DEST/services.$EXT" || { log "ERROR services"; fail=1; }

log "Fase 4b: tar del resto del home"
tar --numeric-owner -cpf - -C "$USER_HOME" \
  --exclude=services --exclude=.vscode-server --exclude=.cache --exclude=.copilot \
  --exclude='*.tmp' . | $COMP > "$DEST/home.$EXT" || { log "ERROR home"; fail=1; }

# ---------- 5. Volúmenes Docker ----------
log "Fase 5: volúmenes Docker con nombre (se omiten los anónimos de 64 hex)"
img=$(docker images --format '{{.Repository}}:{{.Tag}}' | grep -m1 -E '^(alpine|busybox)' || true)
[ -n "$img" ] || { docker pull -q alpine >/dev/null; img=alpine; }
for v in $(docker volume ls -q | grep -vE '^[0-9a-f]{64}$'); do
  log "volumen $v"
  docker run --rm -v "$v":/v:ro "$img" tar --numeric-owner -cpf - -C /v . 2>>"$LOG" | $COMP > "$DEST/volumes/$v.$EXT" \
    || { log "ERROR volumen $v"; fail=1; }
done

# ---------- 6. Checksums ----------
log "Fase 6: checksums"
(cd "$DEST" && find . -type f ! -name SHA256SUMS ! -name backup.log -print0 | xargs -0 sha256sum > SHA256SUMS)
du -sh "$DEST"

if [ "$fail" -ne 0 ]; then log "TERMINÓ CON ERRORES: revisa $LOG"; else log "OK: backup completo en $DEST"; fi
log "Los stacks siguen parados. Para volver a arrancar: cd $SERVICES && ./start.sh"
exit "$fail"
