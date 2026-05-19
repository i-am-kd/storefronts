package handler

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type HealthHandler struct{}

func (h *HealthHandler) Check(c *gin.Context){
	c.JSON(http.StatusOK, gin.H{
		"service":"storefronts-backend",
		"status": "operational",
		"timestamp" :time.Now().UTC(),
	})
}