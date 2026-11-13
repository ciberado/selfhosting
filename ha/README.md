# ha

Home Assistant + Piper/Whisper (voz) + Tailscale.

## Qué es

Home Assistant es una plataforma de domótica local: integra dispositivos (luces, enchufes, mandos IR Broadlink, sensores…), permite automatizaciones y paneles. Incluye Piper (texto a voz) y Whisper (voz a texto) para el asistente de voz.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `ha-server` | `ghcr.io/home-assistant/home-assistant:stable` | - |
| `whisper` | `rhasspy/wyoming-whisper` | 10300:10300 |
| `piper` | `rhasspy/wyoming-piper` | 10200:10200 |
| `ha-ts` | `tailscale/tailscale:latest` | - |

## Rutas del host (bind mounts)

- `./config:/config`
- `./ha-ts/config:/config`
- `./piper-data:/data`
- `./whisper-data:/data`

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

- Solo se versionan `configuration.yaml` y `scenes.yaml`. `config/secrets.yaml`, `.storage/` (usuarios, integraciones, códigos Broadlink…) y la base de datos **no están en el repo**; créalos o restáuralos desde un backup de Home Assistant.
- `copy-codes.sh` copia los códigos del mando Broadlink a la carpeta indicada en la variable de entorno `BACKUP_DIR`.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
