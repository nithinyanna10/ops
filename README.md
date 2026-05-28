# n8n RevOps on Render

Minimal Render Blueprint for n8n **1.111.0** (pinned to avoid 2.x task-runner/Python noise on free tier).

## Deploy

1. Push this repo to GitHub and connect it in Render as a **Blueprint** (or link the repo to the web service).
2. **Manual Deploy** → **Clear build cache & deploy** after config changes.
3. When deploy finishes, copy your real `onrender.com` URL from the dashboard.
4. Update in Render → **Environment** (or edit `render.yaml` and push):
   - `N8N_HOST` = `your-service.onrender.com` (hostname only)
   - `WEBHOOK_URL` = `https://your-service.onrender.com/` (with trailing slash)
5. Redeploy once more.

## Log in

- User: `admin`
- Password: `N8N_BASIC_AUTH_PASSWORD` in Render → Environment

Save `N8N_ENCRYPTION_KEY` — do not change it after first deploy.

## Fix task broker / DB timeout logs

If logs show **Task Broker port 5679**, **Python runner**, or **Database connection timed out**, see **[RENDER_ENV_CLEANUP.md](./RENDER_ENV_CLEANUP.md)** — you are on n8n 2.x or stale env vars, not the pinned `1.111.0` image.

**Critical:** Delete `N8N_RUNNERS_ENABLED` from Render Environment (do not set it to `false`). Remove all `DB_POSTGRESDB_*` vars unless you add a Render Postgres database.

## HTTP 503 / 502?

Render health checks hit `healthCheckPath` **without** basic-auth credentials. If it is `/`, n8n returns **401** and Render marks the instance unhealthy → **503** in the browser.

This blueprint uses `/healthz` (public, returns 200). After changing `render.yaml`, run **Manual Deploy → Clear build cache & deploy**.

Also ensure `N8N_HOST` and `WEBHOOK_URL` match your real `*.onrender.com` hostname (not a placeholder).

## Free tier notes

- Instances **sleep** after ~15 minutes idle; first request after sleep is slow.
- **No Postgres** in this blueprint — workflow data is ephemeral on redeploy.
- `Database connection timed out` on first boot can happen on free tier; wait 2–3 minutes and refresh.
- Success looks like: `Editor is now accessible via: https://your-service.onrender.com`

## Files

| File | Purpose |
|------|---------|
| `render.yaml` | Blueprint: Docker web service, port 5678, basic auth |
| `render.yaml` | `runtime: image` → `docker.io/n8nio/n8n:1.111.0` (not `latest`) |
| `Dockerfile` | Local reference only; Render uses the image URL above |
