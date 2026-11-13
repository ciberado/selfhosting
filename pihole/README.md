# pihole

Pi-hole (DNS con bloqueo de anuncios) accesible por Tailscale.

## Qué es

Pi-hole es un servidor DNS que bloquea publicidad y rastreadores a nivel de red. Aquí se usa a través de Tailscale para filtrar el DNS de los dispositivos de la tailnet.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `tailscale` | `tailscale/tailscale:latest` | - |
| `pihole` | `pihole/pihole:latest` | - |

## Rutas del host (bind mounts)

- `./etc-dnsmasq.d:/etc/dnsmasq.d`
- `./etc-pihole:/etc/pihole`
- `./tailscale-data:/var/lib/tailscale`

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

- Solo se versiona el compose. Los datos (`etc-pihole/`, `etc-dnsmasq.d/`, `tailscale-data/`) no están en el repo: Pi-hole los crea en el primer arranque. La contraseña web se establece con `docker exec pihole pihole setpassword`.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
