# bookorbit

Gestor de biblioteca de libros (BookOrbit) con PostgreSQL y Tailscale.

## Qué es

BookOrbit es un gestor de biblioteca de libros electrónicos autoalojado: escanea una carpeta de libros, organiza metadatos y colecciones, permite leer/descargar y se sincroniza con lectores Kobo. Usa PostgreSQL (con pgvector) como base de datos.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `app` | `${APP_IMAGE?required}` | - |
| `postgres` | `pgvector/pgvector:pg18` | - |
| `bookorbit-ts` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

- `${BOOKS_HOST_PATH:-./books}:/books`
- `./data/app:/data`
- `./data/postgres:/var/lib/postgresql/data`
- `./ts/config:/config`

Las rutas relativas (`./...`) se resuelven respecto a esta carpeta; las absolutas  se parametrizan en `.env` (p. ej. rutas de bibliotecas).

## Configuración

Copia `.env.example` a `.env` y rellena los valores:

```bash
cp .env.example .env
```

Variables que debes rellenar (`<ESCRIBE AQUÍ ...>`):

- `POSTGRES_PASSWORD`
- `JWT_SECRET`
- `SETUP_BOOTSTRAP_TOKEN`
- `APP_URL`
- `CLIENT_SECRET`

## Tailscale

Los servicios usan un sidecar de Tailscale (`tailscale/tailscale`). Necesitas una *auth key* (https://login.tailscale.com/admin/settings/keys) con el tag `tag:container` permitido en tus ACLs; se pone en `.env`. El fichero `ts*.json`/`ts-config` de esta carpeta es la configuración de `tailscale serve` (montada en `/config`).

## Notas

- Define `BOOKS_HOST_PATH` (ruta de tu biblioteca) y los secretos de BD/JWT en `.env`. Genera con `openssl rand -hex 32`.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
