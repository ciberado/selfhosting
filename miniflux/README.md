# miniflux

Lector RSS Miniflux (con PostgreSQL y Caddy) expuesto por Tailscale.

## Qué es

Miniflux es un lector de feeds RSS/Atom minimalista y rápido, con PostgreSQL como base de datos.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `miniflux-server` | `miniflux/miniflux:latest` | - |
| `db` | `postgres:17-alpine` | - |
| `miniflux-ts` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

- `./miniflux-ts/config:/config`

Las rutas relativas (`./...`) se resuelven respecto a esta carpeta; las absolutas  se parametrizan en `.env` (p. ej. rutas de bibliotecas).

## Configuración

Copia `.env.example` a `.env` y rellena los valores:

```bash
cp .env.example .env
```

Variables que debes rellenar (`<ESCRIBE AQUÍ ...>`):

- `CLIENT_SECRET`

## Tailscale

Los servicios usan un sidecar de Tailscale (`tailscale/tailscale`). Necesitas una *auth key* (https://login.tailscale.com/admin/settings/keys) con el tag `tag:container` permitido en tus ACLs; se pone en `.env`. El fichero `ts*.json`/`ts-config` de esta carpeta es la configuración de `tailscale serve` (montada en `/config`).

## Notas

- Las contraseñas de `ADMIN_PASSWORD` y `POSTGRES_PASSWORD` (y la de `DATABASE_URL`, que debe coincidir) están en el propio `docker-compose.yml` como placeholders: edítalas.
- Las suscripciones (`feeds.opml`) no están en el repo; impórtalas desde la interfaz.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
