# services

Configuración de mis servicios Docker Compose, lista para desplegar en otra máquina.
Cada carpeta es un stack independiente con su propio `README.md`.

> Los secretos reales **no** están en el repo. Cada servicio trae un `.env.example`
> con campos `<ESCRIBE AQUÍ ...>` que debes rellenar en un `.env` (ignorado por git).
> Tampoco se versionan los datos persistentes (bases de datos, uploads, estado de Tailscale…).

## Requisitos

- Docker + Docker Compose v2
- Una cuenta de Tailscale y una *auth key* con el tag `tag:container` (casi todos los servicios se publican por Tailscale con un sidecar)
- Sustituye `<TU-TAILNET>` por el nombre de tu tailnet (`xxx.ts.net`) donde aparezca

## Despliegue de un servicio

```bash
cd <servicio>
cp .env.example .env      # rellena los <ESCRIBE AQUÍ ...>
docker compose up -d
```

Revisa el README del servicio: algunos necesitan pasos extra (`mqtt`, `mailflow`, `ha`, `fauxmo`...) y
rutas del host (bibliotecas de fotos, libros, vídeo…) que se definen en el `.env` de cada servicio.

## Servicios

| Carpeta | Descripción |
|---|---|
| [bichon](bichon) | Archivador de correo IMAP |
| [bookorbit](bookorbit) | Gestor de biblioteca de libros |
| [calibrebookdn](calibrebookdn) | Calibre-Web-Automated + descargador |
| [dirtyrss](dirtyrss) | Lector RSS |
| [ethercalc](ethercalc) | Hoja de cálculo colaborativa |
| [etherpad](etherpad) | Editor colaborativo |
| [excalidraw](excalidraw) | Pizarra Excalidraw |
| [fauxmo](fauxmo) | Emulación WeMo → webhooks de Home Assistant |
| [geekslides](geekslides) / [geekslidesv2](geekslidesv2) | Presentaciones |
| [ha](ha) | Home Assistant + voz |
| [immich](immich) | Fotos y vídeos |
| [jellyfin](jellyfin) | Servidor multimedia |
| [mailflow](mailflow) | Cliente de correo web |
| [memos](memos) | Notas |
| [minicalen](minicalen) | Calendario |
| [miniflux](miniflux) | Lector RSS |
| [mqtt](mqtt) | Broker Mosquitto |
| [n8n](n8n) | Automatización |
| [pihole](pihole) | DNS con bloqueo de anuncios |
| [planka](planka) | Kanban |
| [quizzquizz](quizzquizz) / [quizzquizzdev](quizzquizzdev) | Cuestionarios (prod / dev) |
| [readeck](readeck) | Read-it-later |
| [seafile](seafile) | Sincronización de ficheros |
| [verydirtyrss](verydirtyrss) | RSS (código en su propio repo) |

## Scripts

- `start.sh` / `stop.sh`: recorren las carpetas y ejecutan `docker compose up -d` / `down` (ejecútalos desde la raíz del repo; se salta las que terminan en `.off`).
- `backup.sh`: copia los `docker-compose*.yml` y `.env` a `$BACKUP_DIR` (**contiene secretos**: guarda ese backup en un sitio seguro).
- `migrate-backup.sh`: backup completo previo a una migración de máquina.
- `clean.sh`: resume el uso de disco de `docker system df -v`.

## Notas de la sanitización

- Los `.env` originales se convirtieron en `.env.example`; los valores secretos, emails y claves de Tailscale son placeholders.
- Las rutas absolutas `/home/javi/services/<servicio>/...` de los compose se cambiaron a rutas relativas (`./...`).
- El nombre del tailnet se sustituyó por `<TU-TAILNET>`.
- No incluidos a propósito: `cies/` (datos personales), `torrent/` (scripts sueltos), `quizzquizz-dev/` (copia antigua sin compose), `upc/`, ficheros `.bak`/`.bk`, y todo el contenido de datos.
