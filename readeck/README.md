# readeck

Readeck: lectura posterior de artículos, expuesto por Tailscale.

## Qué es

Readeck es un servicio «leer más tarde»: guarda páginas web como artículos limpios, con etiquetas, marcadores y resaltados, y conserva una copia local.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `app` | `codeberg.org/readeck/readeck:latest` | - |
| `ts` | `tailscale/tailscale:latest` | 7777:7777 |

## Rutas del host (bind mounts)

- `./tsconfig:/config`

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
