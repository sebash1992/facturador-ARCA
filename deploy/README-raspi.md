# Correrlo en una Raspberry Pi con todo local (Docker)

El `docker-compose.yml` de la raíz levanta el bot **y la base de datos en tu
Pi**: Postgres + PostgREST reemplazan a Supabase cloud sin tocar el código
(el cliente de supabase-py habla PostgREST por abajo; un nginx interno
traduce la ruta `/rest/v1/`). Nada queda expuesto a tu LAN: los cuatro
containers se hablan por la red interna del stack.

## Pasos

```bash
git clone <este-repo> && cd facturador-arca
cp .env.example .env
```

1. Completá el `.env` como siempre, más las dos variables del stack local:
   `DB_PASSWORD` (inventá una) y `CERTS_DIR` (carpeta del host con el
   cert/key de ARCA, ej `/home/pi/.arca-facturador` — creala aunque estés
   en homologación). `SUPABASE_URL` y `SUPABASE_SECRET_KEY` quedan vacías.
2. `AFIP_CERT_PATH` y `AFIP_KEY_PATH` son rutas **dentro del container**:
   `/certs/<archivo>`.
3. Levantá el stack:

   ```bash
   docker compose up -d --build
   ```

   En Portainer: Stacks → Add stack → Repository, apuntando a este repo
   (o Upload del compose). El schema se aplica solo en el primer arranque.

4. Probá en homologación (`PRODUCTION=false`) y recién después pasá a
   producción.

## Notas

- **Backup**: la DB vive en el volumen `pgdata` de la Pi. Un cron con
  `docker compose exec db pg_dump -U postgres facturador > backup.sql`
  te salva de una SD quemada.
- **Reloj**: la Pi no tiene RTC; asegurate NTP activo (default en Pi OS).
  Las validaciones de fecha de ARCA dependen del reloj del sistema.
- **Qué sigue siendo remoto**: Telegram, y el Afip SDK (firma WSAA y genera
  el PDF en sus servidores — ver la nota de seguridad del README principal).
- **Volver a Supabase cloud**: borrá los overrides `SUPABASE_URL` /
  `SUPABASE_SECRET_KEY` del servicio `bot` en el compose y completá las
  del `.env`.
