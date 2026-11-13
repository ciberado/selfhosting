# verydirtyrss

VeryDirtyRSS (`ciberado/verydirtyrss`) expuesto por Tailscale.

## Qué es

VeryDirtyRSS es una aplicación propia (Node/TypeScript) para leer feeds RSS de forma sucia pero rápida, expuesta por HTTPS en tu tailnet mediante `tailscale serve`.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `tailscale` | `tailscale/tailscale:latest` | - |
| `verydirtyrss` | `ciberado/verydirtyrss:latest` | - |

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

- El código fuente y el `Dockerfile` viven en https://github.com/ciberado/verydirtyrss; aquí solo se versiona el despliegue (la imagen es `ciberado/verydirtyrss`).

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
