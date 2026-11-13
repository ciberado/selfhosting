# geekslides

GeekSlides (v1): visor de presentaciones expuesto por Tailscale.

## Qué es

GeekSlides es una herramienta para publicar presentaciones (decks) de diapositivas, normalmente escritas en Markdown, y visualizarlas desde el navegador. Esta es la primera versión.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `geekslides-slides` | `ciberado/geekslides-slides:latest` | - |
| `geekslides-broker` | `ciberado/geekslides-broker:latest` | - |
| `geekslides-ts` | `tailscale/tailscale:latest` | - |

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
