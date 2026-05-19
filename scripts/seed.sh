#!/user/bin/env bash 

set -euo pipefail 

DB_URL="postgresql://${DB_USER:-postgres}:${DB_PASSWORD:-}@${DB_HOST:-localhost}:${DB_PORT:-5432}/@{DB_NAME:-storefronts}?sslmode=${DB_SSLMODE:-disable}"

echo "🌱 Applying seed data..."
psql "$DB_URL" -f ./database/seeds/seed.sql
echo "✅ Seed complete."