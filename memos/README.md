# memos

Notas rápidas con Memos expuestas por Tailscale.

## Qué es

Memos es una aplicación de notas rápidas autoalojada, estilo microblog, con Markdown, etiquetas y búsqueda.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `memos-ts` | `tailscale/tailscale:latest` | - |
| `memos` | `neosmemo/memos:stable` | - |

## Rutas del host (bind mounts)

- `./data:/var/opt/memos`
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

- `data/` (base de datos y adjuntos) no se versiona.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
