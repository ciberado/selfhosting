# mailflow

MailFlow: cliente de correo web (backend, frontend, Postgres, Redis) con Tailscale.

## Qué es

MailFlow es un cliente de correo web autoalojado que se conecta a tus cuentas IMAP/OAuth, con notificaciones push y almacenamiento cifrado de credenciales. Incluye backend, frontend, PostgreSQL y Redis.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `frontend` | `ghcr.io/maathimself/mailflow-frontend:${MAILFLOW_VERSION:-latest}` | - |
| `backend` | `ghcr.io/maathimself/mailflow-backend:${MAILFLOW_VERSION:-latest}` | - |
| `postgres` | `postgres:16-alpine` | - |
| `redis` | `redis:7-alpine` | - |
| `caddy` | `caddy:2-alpine` | - |
| `mailflow-ts` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

- `./certs:/etc/nginx/ssl`
- `./ts/config:/config`

Las rutas relativas (`./...`) se resuelven respecto a esta carpeta; las absolutas  se parametrizan en `.env` (p. ej. rutas de bibliotecas).

## Configuración

Copia `.env.example` a `.env` y rellena los valores:

```bash
cp .env.example .env
```

Variables que debes rellenar (`<ESCRIBE AQUÍ ...>`):

- `APP_URL`
- `SESSION_SECRET`
- `DB_PASSWORD`
- `ENCRYPTION_KEY`
- `VAPID_SUBJECT`
- `DOMAIN`
- `ACME_EMAIL`
- `VITE_EMAIL_DIV_RENDER`
- `CLIENT_SECRET`

## Tailscale

Los servicios usan un sidecar de Tailscale (`tailscale/tailscale`). Necesitas una *auth key* (https://login.tailscale.com/admin/settings/keys) con el tag `tag:container` permitido en tus ACLs; se pone en `.env`. El fichero `ts*.json`/`ts-config` de esta carpeta es la configuración de `tailscale serve` (montada en `/config`).

## Notas

- Los certificados TLS (`certs/cert.pem` y `certs/key.pem`) **no están en el repo**. Genera uno autofirmado:
  ```bash
  mkdir -p certs && openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout certs/key.pem -out certs/cert.pem -subj '/CN=mailflow'
  ```
- Genera los secretos con `openssl rand -hex 32` (`SESSION_SECRET`, `ENCRYPTION_KEY`) y `openssl rand -hex 16` (`DB_PASSWORD`). **No pierdas `ENCRYPTION_KEY`**: cifra las credenciales guardadas.
- Claves VAPID (opcionales): `npx web-push generate-vapid-keys`.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
