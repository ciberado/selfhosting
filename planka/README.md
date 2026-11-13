# planka

Tableros kanban Planka con PostgreSQL y Tailscale.

## Qué es

Planka es un gestor de proyectos estilo Trello: tableros kanban con listas, tarjetas, etiquetas y colaboración.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `planka` | `ghcr.io/plankanban/planka:2.0.0-rc.2` | - |
| `postgres` | `postgres:16-alpine` | - |
| `planka-ts` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

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

## Notas

- `SECRET_KEY` está en el propio `docker-compose.yml` como placeholder: genera una con `openssl rand -hex 32`.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
