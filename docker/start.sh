#!/bin/sh
set -eu
: "${SCANNER_SECRET:?Set SCANNER_SECRET in environment}"
node /app/docker/gateway.mjs &
GATEWAY_PID=$!
npx wrangler dev -c wrangler.local.jsonc --ip 127.0.0.1 --port 8787 --persist-to /app/.wrangler/state --local --var "SCANNER_SECRET:$SCANNER_SECRET" &
WORKER_PID=$!
trap 'kill "$GATEWAY_PID" "$WORKER_PID" 2>/dev/null || true' EXIT INT TERM
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
