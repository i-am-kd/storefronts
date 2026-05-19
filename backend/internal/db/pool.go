package db

import (
	"context"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

type Config struct{
	Host string 
	Port string 
	User string
	Password string
	DBName string
	SSLMode string
	MaxConns int32 
}

func NewPool(ctx context.Context, cfg Config) (*pgxpool.Pool, error){
	dsn := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
		cfg.Host, cfg.Port, cfg.User, cfg.Password, cfg.DBName, cfg.SSLMode,
	)
	poolConfig, err := pgxpool.ParseConfig(dsn)
	if err != nil{
		return nil, fmt.Errorf("failed to parse connection string: %w", err)
	}
	poolConfig.MaxConns = cfg.MaxConns
	poolConfig.MinConns = cfg.MaxConns/2
	poolConfig.MaxConnLifetime = 1*time.Hour
	poolConfig.MaxConnIdleTime = 10*time.Minute

	pool, err := pgxpool.NewWithConfig(ctx, poolConfig)
	if err != nil {
		return nil, fmt.Errorf("failed to create connection pool: %w", err)
	}
	if err := pool.Ping(ctx); err !=nil {
		return nil, fmt.Errorf("failed to ping database: %w", err)
	}
	return pool, nil
}

func InjectTenantContext (ctx context.Context, conn *pgxpool.Conn, tenantID string) error {
	_, err := conn.Exec(ctx, "SET LOCAL app.tenant_id =$1", tenantID)
	return err
}