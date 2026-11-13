# quizzquizzdev

QuizzQuizz: entorno de desarrollo con Caddy y Tailscale.

## Qué es

Instancia de desarrollo/pruebas de QuizzQuizz (cuestionarios tipo test a partir de bancos de preguntas en Markdown), con versión y autenticación configurables.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `quizzquizz` | `ciberado/quizzquizz:${VERSION}` | - |
| `caddy` | `caddy:2-alpine` | - |
| `quizzquizz-ts` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

- `./Caddyfile:/etc/caddy/Caddyfile:ro`
- `./data:/data`
- `./question-banks:/app/question-banks:ro`
- `./ts-config:/config:ro`

Las rutas relativas (`./...`) se resuelven respecto a esta carpeta; las absolutas  se parametrizan en `.env` (p. ej. rutas de bibliotecas).

## Configuración

Copia `.env.example` a `.env` y rellena los valores:

```bash
cp .env.example .env
```

Variables que debes rellenar (`<ESCRIBE AQUÍ ...>`):

- `TAILNET_DOMAIN`
- `TS_AUTHKEY`
- `BETTER_AUTH_SECRET`
- `BETTER_AUTH_BASE_URL`
- `CORS_ORIGIN`

## Tailscale

Los servicios usan un sidecar de Tailscale (`tailscale/tailscale`). Necesitas una *auth key* (https://login.tailscale.com/admin/settings/keys) con el tag `tag:container` permitido en tus ACLs; se pone en `.env`. El fichero `ts*.json`/`ts-config` de esta carpeta es la configuración de `tailscale serve` (montada en `/config`).

## Notas

- Los bancos de preguntas (`question-banks/`) viven en https://github.com/ciberado/question-banks — clónalo aquí. `data/` (SQLite) no se versiona.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
