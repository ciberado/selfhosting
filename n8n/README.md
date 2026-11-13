# n8n

Automatización de flujos n8n expuesta por Tailscale.

## Qué es

n8n es una plataforma de automatización de flujos de trabajo (similar a Zapier) con editor visual y cientos de integraciones.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `n8n` | `docker.n8n.io/n8nio/n8n:latest` | - |
| `n8n-ts` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

- `./config:/config`
- `./n8n-data:/home/node/.n8n`

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

- `n8n-data/` (base de datos SQLite con workflows y credenciales cifradas) no se versiona: exporta tus workflows desde la UI o haz backup de esa carpeta junto con la `N8N_ENCRYPTION_KEY`.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
