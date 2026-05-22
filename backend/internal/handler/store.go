package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/i-am-kd/storefronts/internal/context"
	"github.com/i-am-kd/storefronts/internal/db"
	"github.com/jackc/pgx/v5/pgxpool"
)

type StoreHandler struct{
	Pool *pgxpool.Pool
}

func (h *StoreHandler) GetInventory(c *gin.Context){
	storeID, exists := c.Get(string(context.StoreIDKey))
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error":"unauthorized: stroe identifier not found"})
		return
	}

	storeIDstr, ok := storeID.(string)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error":"invlid store indetifier format "})
		return
	}

	tx, err := db.BeginTenantTx(c.Request.Context(), h.Pool, storeIDstr)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error":"failed to initiaize context", "details": err.Error()})
		return 
	}
	defer tx.Rollback(c.Request.Context())

	//example tenant scoped query (RLS enforces isolation automatically)
	var count int 
	err = tx.QueryRow(c.Request.Context(), "SELECT COUNT (*) FROM products WHERE status='active'").Scan(&count)
	if err !=nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error":"query failed"})
		return
	}
	tx.Commit(c.Request.Context())
	c.JSON(http.StatusOK, gin.H{"store_id": storeID, "active_products":count})
}