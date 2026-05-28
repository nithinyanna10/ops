# Pin 1.x — avoids 2.x task runners, Python broker, and heavy migrations on Render free tier
FROM docker.io/n8nio/n8n:1.111.0

# Fail the build if Render ever pulls the wrong tag
RUN n8n --version 2>&1 | grep -qE '^1\.111\.'

EXPOSE 5678
