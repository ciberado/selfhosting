# excalidraw

Pizarra Excalidraw con Caddy y Tailscale.

## Qué es

Excalidraw es una pizarra virtual con estilo de dibujo a mano para hacer diagramas y esquemas, con colaboración en tiempo real. Este stack despliega el frontend y los servicios de backend de rooms/almacenamiento, detrás de Caddy.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `caddy` | `caddy:2-alpine` | - |
| `frontend` | `alswl/excalidraw:v0.18.1-fork-b2` | - |
| `storage` | `alswl/excalidraw-storage-backend:v2023.11.11` | - |
| `room` | `excalidraw/excalidraw-room:sha-49bf529` | - |
| `excalidraw-ts` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

- `./caddy/Caddyfile:/etc/caddy/Caddyfile:ro`
- `./ts/config:/config`

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

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
