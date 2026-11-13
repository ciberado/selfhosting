# ethercalc

Hoja de cálculo colaborativa Ethercalc expuesta por Tailscale.

## Qué es

Ethercalc es una hoja de cálculo web colaborativa en tiempo real: varias personas editan la misma hoja a la vez desde el navegador.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `ethercalc` | `node:14-alpine` | - |
| `redis` | `redis:latest` | - |
| `ethercalc-ts` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

- `./ethercalc-ts/config:/config`

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
