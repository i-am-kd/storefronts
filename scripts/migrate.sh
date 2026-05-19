#!/usr/bin/env bash
set -euo pipefail

DB_URL="postgresql://${DB_USER:-postgres}:${DB_PASSWORD:-}@${DB_HOST:-localhost}:${DB_PORT:-5432}/${DB_NAME:-storefronts}?sslmode=${DB_SSLMODE:-disable}"

case "${1:-up}" in
  up)
    echo "⬆️  Applying migrations..."
    goose -dir ./database/migrations postgres "$DB_URL" up
    ;;
  down)
    echo "⬇️  Rolling back last migration..."
    goose -dir ./database/migrations postgres "$DB_URL" down
    ;;
  reset)
    echo "🗑️  Resetting database..."
    goose -dir ./database/migrations postgres "$DB_URL" reset
    ;;
  status)
    goose -dir ./database/migrations postgres "$DB_URL" status
    ;;
  *)
    echo "Usage: $0 {up|down|reset|status}"
    exit 1
    ;;
esac