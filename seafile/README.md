# seafile

Seafile (sincronización de ficheros) con MariaDB, Memcached, Caddy y Tailscale.

## Qué es

Seafile es una plataforma de sincronización y compartición de ficheros (tipo Dropbox) con bibliotecas cifradas, edición de documentos (SeaDoc) y servidor de notificaciones. Usa MariaDB y Memcached.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `db` | `${SEAFILE_DB_IMAGE:-mariadb:10.11}` | - |
| `memcached` | `${SEAFILE_MEMCACHED_IMAGE:-memcached:1.6.29}` | - |
| `seafile` | `${SEAFILE_IMAGE:-seafileltd/seafile-mc:12.0-latest}` | - |
| `seafile-ts` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

- `${SEAFILE_MYSQL_VOLUME:-/opt/seafile-mysql/db}:/var/lib/mysql`
- `${SEAFILE_VOLUME}:/shared`
- `./ts/config:/config`

Las rutas relativas (`./...`) se resuelven respecto a esta carpeta; las absolutas  se parametrizan en `.env` (p. ej. rutas de bibliotecas).

## Configuración

Copia `.env.example` a `.env` y rellena los valores:

```bash
cp .env.example .env
```

Variables que debes rellenar (`<ESCRIBE AQUÍ ...>`):

- `INIT_SEAFILE_MYSQL_ROOT_PASSWORD`
- `SEAFILE_MYSQL_DB_PASSWORD`
- `JWT_PRIVATE_KEY`
- `SEAFILE_SERVER_HOSTNAME`
- `INIT_SEAFILE_ADMIN_EMAIL`
- `INIT_SEAFILE_ADMIN_PASSWORD`
- `CLIENT_SECRET`

## Tailscale

Los servicios usan un sidecar de Tailscale (`tailscale/tailscale`). Necesitas una *auth key* (https://login.tailscale.com/admin/settings/keys) con el tag `tag:container` permitido en tus ACLs; se pone en `.env`. El fichero `ts*.json`/`ts-config` de esta carpeta es la configuración de `tailscale serve` (montada en `/config`).

## Notas

- `COMPOSE_FILE=seafile-server.yml` en `.env` selecciona qué ficheros se combinan (`seadoc.yml`, `caddy.yml`...). `docker-compose.yml` y `seafile-server.yml` son equivalentes.
- Los volúmenes de datos (`SEAFILE_VOLUME`, `SEAFILE_MYSQL_VOLUME`, …) apuntan a rutas del host; `SEADOC_VOLUME` y `NOTIFICATION_SERVER_VOLUME` debes rellenarlas.
- `INIT_SEAFILE_*` solo se usan en la primera inicialización.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
