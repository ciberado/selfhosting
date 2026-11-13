# minicalen

Minicalen: calendario minimalista con Tailscale.

## Qué es

Minicalen es una aplicación propia (`ciberado/minicalen`) de calendario minimalista con autenticación (Better Auth).

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `minicalen` | `ciberado/minicalen:${IMAGE_TAG:-latest}` | - |
| `minicalen-ts` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

- `${DATA_DIR:-./data}:/app/data`

Las rutas relativas (`./...`) se resuelven respecto a esta carpeta; las absolutas  se parametrizan en `.env` (p. ej. rutas de bibliotecas).

## Configuración

Copia `.env.example` a `.env` y rellena los valores:

```bash
cp .env.example .env
```

Variables que debes rellenar (`<ESCRIBE AQUÍ ...>`):

- `CLIENT_SECRET`
- `BETTER_AUTH_SECRET`
- `BETTER_AUTH_URL`
- `ALLOWED_ORIGINS`

## Tailscale

Los servicios usan un sidecar de Tailscale (`tailscale/tailscale`). Necesitas una *auth key* (https://login.tailscale.com/admin/settings/keys) con el tag `tag:container` permitido en tus ACLs; se pone en `.env`. El fichero `ts*.json`/`ts-config` de esta carpeta es la configuración de `tailscale serve` (montada en `/config`).

## Notas

- Hay dos ficheros compose: `docker-compose.yaml` y `docker-compose.yml`. Docker Compose emite un aviso y usa `docker-compose.yml`; `docker-compose.yaml` incluye el sidecar de Tailscale (revisa cuál quieres conservar y borra el otro).

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
