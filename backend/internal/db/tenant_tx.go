package db

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

// Begin TenantTx starts with transaction and injects the tenant ID for RLS inforcement
func BeginTenantTx(ctx context.Context, pool *pgxpool.Pool, tenantID string)(pgx.Tx, error){
	tx, err := pool.Begin(ctx)
	if err != nil{
		return nil, fmt.Errorf("failed to begin transaction: %w", err)
	}

	_, err  = tx.Exec(ctx, "SET LOCAL app.tenant_id = $1", tenantID)
	if err != nil{
		tx.Rollback(ctx)
		return nil, fmt.Errorf("failed to set tenant context: %w", err)
	}
	return tx, nil
}