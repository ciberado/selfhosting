# dirtyrss

Lector/agregador RSS `dirtyrss` expuesto por Tailscale.

## Qué es

Aplicación propia (`ciberado/dirtyrss`) para consumir feeds RSS de forma rápida, expuesta únicamente dentro de tu tailnet.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `dirtyrss-server` | `ciberado/dirtyrss` | - |
| `dirtyrss-ts` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

- `./ts:/config`

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
