package middleware

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

func CORS() gin.HandlerFunc{
	return func(c *gin.Context){
		c.Header("Access-Control-Allow-Orign", "*") // restrict in public production
		c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Origin, Content-Type, Authorization")
		if c.Request.Method =="Options"{
			c.AbortWithStatus(http.StatusNoContent)
			return
		}
		c.Next()
	}
}

func RequestLogger() gin.HandlerFunc{
	return func (c *gin.Context){
		start := time.Now()
		c.Next()
		duration :=time.Since(start)
		status := c.Writer.Status()

		c.Request.Context().Value("logger") // placeholder for slog/zap integration
		_ = duration
		_ = status
	}
}