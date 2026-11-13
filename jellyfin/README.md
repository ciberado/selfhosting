# jellyfin

Servidor multimedia Jellyfin expuesto por Tailscale.

## Qué es

Jellyfin es un servidor multimedia libre: organiza y reproduce en streaming películas, series, música y fotos desde cualquier dispositivo.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `jellyfin` | `jellyfin/jellyfin` | - |
| `ts-jellyfin` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

- `./cache:/cache`
- `./config/:/config`
- `./nginx/conf/:/certs`
- `./ts-jellyfin/config:/config`
- `${MEDIA_PATH}:/data`

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

- Define `MEDIA_PATH` en `.env` (carpeta del host con tu biblioteca multimedia). La config de Jellyfin (`config/`) se genera sola.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
