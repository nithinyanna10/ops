# Render environment cleanup (required once)

Your logs show **n8n 2.x** behavior (task broker on 5679, Python runner, new migrations).
That means Render is **not** running the pinned `1.111.0` Docker build yet, and/or stale env vars remain.

## Delete these in Render → n8n-qoma → Environment

Remove every variable below if it exists (Blueprint does **not** delete old keys automatically):

### Task runners (causes broker / grant token / 403 errors)

- `N8N_RUNNERS_ENABLED` — **delete** (do not set to `false`; 2.x treats presence as legacy config)
- `N8N_RUNNERS_MODE`
- `N8N_RUNNERS_GRANT_TOKEN_TTL`
- `N8N_RUNNERS_BROKER_PORT`
- `N8N_RUNNERS_AUTH_TOKEN`
- `N8N_RUNNERS_BROKER_LISTEN_ADDRESS`
- `N8N_NATIVE_PYTHON_RUNNER`
- `N8N_PYTHON_ENABLED`

### Postgres (causes "Database connection timed out" when no DB exists)

- `DB_TYPE` if set to `postgresdb` (Blueprint sets `sqlite` — keep that)
- `DB_POSTGRESDB_HOST`
- `DB_POSTGRESDB_PORT`
- `DB_POSTGRESDB_DATABASE`
- `DB_POSTGRESDB_USER`
- `DB_POSTGRESDB_PASSWORD`
- `DB_POSTGRESDB_SCHEMA`
- `DATABASE_URL`

## Confirm deploy uses this repo's Dockerfile

Render → **Settings** → Build & Deploy:

- **Language:** Docker
- **Dockerfile path:** `./Dockerfile`
- **Not** "Existing Image" / `n8nio/n8n:latest`

Then: **Manual Deploy** → **Clear build cache & deploy**.

## Healthy logs (1.111.0)

You should **not** see:

- `n8n Task Broker ready on 127.0.0.1, port 5679`
- `Failed to start Python task runner`
- `N8N_RUNNERS_ENABLED -> Remove this environment variable`

You **should** see:

```text
Editor is now accessible via:
https://n8n-qoma.onrender.com
```
