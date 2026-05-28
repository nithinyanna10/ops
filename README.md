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

## Remove stale env vars in Render

In **Environment**, delete if present (leftover from older configs):

- `N8N_RUNNERS_ENABLED`
- `N8N_RUNNERS_MODE`
- `N8N_RUNNERS_GRANT_TOKEN_TTL`
- `N8N_RUNNERS_BROKER_PORT`
- `N8N_PYTHON_ENABLED`

This MVP does not use task runners.

## Free tier notes

- Instances **sleep** after ~15 minutes idle; first request after sleep is slow.
- **No Postgres** in this blueprint — workflow data is ephemeral on redeploy.
- `Database connection timed out` on first boot can happen on free tier; wait 2–3 minutes and refresh.
- Success looks like: `Editor is now accessible via: https://your-service.onrender.com`

## Files

| File | Purpose |
|------|---------|
| `render.yaml` | Blueprint: Docker web service, port 5678, basic auth |
| `Dockerfile` | Pins `n8nio/n8n:1.111.0` |
