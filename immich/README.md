# immich

Immich: gestión de fotos y vídeos (con PostgreSQL, ML y Tailscale).

## Qué es

Immich es una alternativa autoalojada a Google Photos: copia de seguridad de fotos y vídeos desde el móvil, reconocimiento de caras, búsqueda semántica con aprendizaje automático, álbumes compartidos y más.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `immich-server` | `ghcr.io/immich-app/immich-server:${IMMICH_VERSION:-release}` | - |
| `immich-machine-learning` | `ghcr.io/immich-app/immich-machine-learning:${IMMICH_VERSION:-release}` | - |
| `redis` | `docker.io/redis:6.2-alpine@sha256:e3b17ba9479deec4b7d1eeec1548a253acc5374d68d3b27937fcfe4df8d18c7e` | - |
| `database` | `ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23` | - |
| `photos-ts` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

- `${DB_DATA_LOCATION}:/var/lib/postgresql/data`
- `${UPLOAD_LOCATION}:/usr/src/app/upload`
- `./ts:/config`
- `/etc/localtime:/etc/localtime:ro`

Las rutas relativas (`./...`) se resuelven respecto a esta carpeta; las absolutas  se parametrizan en `.env` (p. ej. rutas de bibliotecas).

## Configuración

Copia `.env.example` a `.env` y rellena los valores:

```bash
cp .env.example .env
```

Variables que debes rellenar (`<ESCRIBE AQUÍ ...>`):

- `DB_PASSWORD`
- `CLIENT_SECRET`

## Tailscale

Los servicios usan un sidecar de Tailscale (`tailscale/tailscale`). Necesitas una *auth key* (https://login.tailscale.com/admin/settings/keys) con el tag `tag:container` permitido en tus ACLs; se pone en `.env`. El fichero `ts*.json`/`ts-config` de esta carpeta es la configuración de `tailscale serve` (montada en `/config`).

## Notas

- `UPLOAD_LOCATION` (en `.env`) apunta a la biblioteca de fotos del host (rellénala). `DB_DATA_LOCATION` es la base de datos Postgres (no versionada).
- `hwaccel.*.yml` son las extensiones de aceleración hardware (referenciadas con `extends` desde el compose).
- `immich.bat` es un script Windows para copiar fotos a la biblioteca; ajusta las rutas.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
