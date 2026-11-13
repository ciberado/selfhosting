# geekslidesv2

GeekSlides v2 (hub + visor) con Caddy y Tailscale.

## Qué es

Segunda versión de GeekSlides: añade un «hub» con login (GitHub/Google OAuth), gestión de usuarios y visor de presentaciones, publicado con Tailscale y un Caddy público opcional.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `geekslidesv2-ts` | `tailscale/tailscale:latest` | - |
| `geekslidesv2` | `ciberado/geekslides:${version}` | - |
| `geekslidesv2-hub` | `ciberado/geekslides-hub:${version}` | - |

## Rutas del host (bind mounts)

- `./Caddyfile.internal:/etc/caddy/Caddyfile:ro`
- `./data/hub:/data`
- `./data/tailscale:/var/lib/tailscale`
- `./ts-config:/config:ro`

Las rutas relativas (`./...`) se resuelven respecto a esta carpeta; las absolutas  se parametrizan en `.env` (p. ej. rutas de bibliotecas).

## Configuración

Copia `.env.example` a `.env` y rellena los valores:

```bash
cp .env.example .env
```

Variables que debes rellenar (`<ESCRIBE AQUÍ ...>`):

- `TS_AUTHKEY`
- `TS_HOSTNAME`
- `TS_TAILNET`
- `VIEWER_BASE_URL`
- `ADMIN_EMAIL`
- `COOKIE_DOMAIN`

## Tailscale

Los servicios usan un sidecar de Tailscale (`tailscale/tailscale`). Necesitas una *auth key* (https://login.tailscale.com/admin/settings/keys) con el tag `tag:container` permitido en tus ACLs; se pone en `.env`. El fichero `ts*.json`/`ts-config` de esta carpeta es la configuración de `tailscale serve` (montada en `/config`).

## Notas

- Rellena los secretos de OAuth/JWT en `.env` (ver comentarios dentro del fichero). `JWT_SECRET`: `openssl rand -hex 32`.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
