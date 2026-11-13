# quizzquizz

QuizzQuizz: aplicación de cuestionarios con Caddy y Tailscale (producción).

## Qué es

QuizzQuizz es una aplicación propia (`ciberado`) para hacer cuestionarios tipo test a partir de bancos de preguntas escritos en Markdown (p. ej. preparación de certificaciones). Esta es la instancia de producción.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `quizzquizz` | `ciberado/quizzquizz:0.0.1` | - |
| `caddy` | `caddy:2-alpine` | - |
| `quizzquizz-ts` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

- `./Caddyfile:/etc/caddy/Caddyfile:ro`
- `./question-banks:/app/question-banks:ro`
- `./ts-config:/config:ro`

Las rutas relativas (`./...`) se resuelven respecto a esta carpeta; las absolutas  se parametrizan en `.env` (p. ej. rutas de bibliotecas).

## Configuración

Copia `.env.example` a `.env` y rellena los valores:

```bash
cp .env.example .env
```

Variables que debes rellenar (`<ESCRIBE AQUÍ ...>`):

- `TS_AUTHKEY`
- `TAILNET_DOMAIN`

## Tailscale

Los servicios usan un sidecar de Tailscale (`tailscale/tailscale`). Necesitas una *auth key* (https://login.tailscale.com/admin/settings/keys) con el tag `tag:container` permitido en tus ACLs; se pone en `.env`. El fichero `ts*.json`/`ts-config` de esta carpeta es la configuración de `tailscale serve` (montada en `/config`).

## Notas

- Los bancos de preguntas (`question-banks/`) viven en su propio repositorio: https://github.com/ciberado/question-banks — clónalo dentro de esta carpeta. `data/` (SQLite) no se versiona.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
