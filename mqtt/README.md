# mqtt

Broker MQTT Eclipse Mosquitto expuesto por Tailscale.

## Qué es

Eclipse Mosquitto es un broker MQTT, el protocolo de mensajería ligera habitual en IoT. Escucha en el puerto 1883 (MQTT) y 9001 (WebSockets) y exige usuario y contraseña.

## Servicios

| Servicio | Imagen | Puertos |
|---|---|---|
| `mqtt` | `eclipse-mosquitto` | - |
| `mqtt-ts` | `tailscale/tailscale:latest` | 1883:1883, 9001:9001 |

## Rutas del host (bind mounts)

- `./config:/mosquitto/config:rw`
- `./data:/mosquitto/data:rw`
- `./log:/mosquitto/log:rw`

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

- `config/pwfile` (usuarios/contraseñas de Mosquitto) **no está en el repo**. Créalo tras el primer arranque:
  ```bash
  mkdir -p config data log
  touch config/pwfile
  docker compose run --rm mqtt mosquitto_passwd -b /mosquitto/config/pwfile <usuario> <password>
  ```
- `allow_anonymous false`: sin `pwfile` nadie podrá conectar.

## Despliegue

```bash
docker compose up -d
docker compose logs -f
```

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
