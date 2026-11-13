# bichon

Archivador de correo (IMAP) con búsqueda full-text (rustmailer/bichon) detrás de Tailscale.

## Qué es

Bichon es un archivador de correo: se conecta por IMAP a tus cuentas, descarga y guarda todos los mensajes (en formato `.eml`), los indexa para búsqueda de texto completo y ofrece una interfaz web y una API REST para consultarlos. No envía correo; sirve para conservar y buscar el histórico.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `bichon-server` | `rustmailer/bichon:latest` | - |
| `bichon-ts` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

- `./bichon-data:/data`
- `./config:/config`

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

- `bichon-data/` (correo archivado, índices) puede ocupar muchos GB y no se versiona.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
