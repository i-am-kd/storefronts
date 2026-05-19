# Variables
DB_USER ?= storefronts_admin
DB_PASSWORD ?= supersecurepass
DB_HOST ?= localhost
DB_PORT ?= 5432
DB_NAME ?= storefronts
DB_SSLMODE ?= disable

export DB_USER DB_PASSWORD DB_HOST DB_PORT DB_NAME DB_SSLMODE

.PHONY: setup dev docker-up docker-down db-setup db-migrate db-migrate-down db-reset db-status db-seed test lint format

# Database operations
db-migrate:
	@echo "⬆️  Applying migrations..."
	@./scripts/migrate.sh up

db-migrate-down:
	@echo "⬇️  Rolling back last migration..."
	@./scripts/migrate.sh down

db-reset:
	@echo "🗑️  Resetting database..."
	@./scripts/migrate.sh reset

db-status:
	@echo "📊 Migration status:"
	@./scripts/migrate.sh status

db-setup:
	@echo "🔧 Enabling PostGIS..."
	@PGPASSWORD=$(DB_PASSWORD) psql -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER) -d $(DB_NAME) -c "CREATE EXTENSION IF NOT EXISTS postgis;" || true

db-seed:
	@echo "🌱 Seeding database..."
	@PGPASSWORD=$(DB_PASSWORD) psql -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER) -d $(DB_NAME) -f database/seeds/seed.sql || echo "⚠️  No seed file found"

# Development
dev:
	@echo "🚀 Storefronts Development"
	@echo "   Backend:  http://localhost:8080"
	@echo "   Frontend: http://localhost:5173"
	@echo "   Database: $(DB_NAME) on $(DB_HOST):$(DB_PORT)"

docker-up:
	@docker compose up -d

docker-down:
	@docker compose down

# Setup
setup:
	@echo "📦 Installing Go dependencies..."
	@cd backend && go mod tidy
	@echo "📦 Installing Node dependencies..."
	@cd frontend && npm install

# Testing
test:
	@cd backend && go test ./... -v -cover
	@cd frontend && npm run test

# Linting
lint:
	@cd backend && go vet ./...
	@cd frontend && npx eslint "src/**/*.{ts,tsx}"

# Formatting
format:
	@cd backend && gofmt -w .
	@cd frontend && npx prettier --write "src/**/*.{ts,tsx,css}"

# Help
help:
	@echo "Available targets:"
	@echo "  setup           Install dependencies"
	@echo "  dev             Show dev environment info"
	@echo "  docker-up       Start Docker services"
	@echo "  docker-down     Stop Docker services"
	@echo "  db-setup        Enable PostGIS"
	@echo "  db-migrate      Apply migrations (up)"
	@echo "  db-migrate-down Rollback last migration"
	@echo "  db-reset        Reset all migrations"
	@echo "  db-status       Show migration status"
	@echo "  db-seed         Seed database"
	@echo "  test            Run tests"
	@echo "  lint            Lint code"
	@echo "  format          Format code"