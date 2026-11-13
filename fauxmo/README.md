# fauxmo

Emulación de dispositivos WeMo (Alexa) que dispara webhooks de Home Assistant.

## Qué es

Fauxmo emula dispositivos Belkin WeMo en la red local para que Alexa pueda encenderlos/apagarlos por voz. Cada dispositivo ejecuta una petición HTTP (aquí, webhooks de Home Assistant, por ejemplo para el aire acondicionado).

## Notas

- No es un compose: se arranca con `./fauxmo.sh` (usa `--network=host`).
- Los IDs de los webhooks de `config.json` son secretos: copia el ID real desde Home Assistant (Automatizaciones → Webhook).

## No incluido en el repo

Datos persistentes, bases de datos, logs y secretos reales (`.env`).
