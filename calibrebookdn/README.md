# calibrebookdn

Calibre-Web-Automated + descargador de libros, expuestos por Tailscale.

## Qué es

Combina Calibre-Web-Automated (interfaz web sobre una biblioteca Calibre, con importación automática de libros desde una carpeta de ingesta) con una herramienta de descarga de libros que deja los ficheros en esa carpeta.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `calibre-web-automated-book-downloader` | `ghcr.io/calibrain/shelfmark:latest` | - |
| `ts` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

- `./config/calibre:/calibre-config`
- `./config/downloader:/config`
- `./tsconfig:/config`
- `${BOOKS_INGEST_PATH}:/books`

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

- Define `BOOKS_INGEST_PATH` en `.env` (carpeta del host con los libros a importar). `config/calibre/` contiene credenciales y no se versiona.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
