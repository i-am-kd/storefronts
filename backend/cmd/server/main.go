package main 

import (
	"log"
	"net/http"
	"os"
	"github.com/gin-gonic/gin"
)

func main(){
	log.Println("[Storefronts] Initializing backend service...")

	gin.SetMode(gin.ReleaseMode)
	r:= gin.New()
	r.Use(gin.Recovery(), gin.Logger())

	r.GET("/health", func(c *gin.Context){
		c.JSON(http.StatusOK, gin.H{
			"service":"Storefronts-backend",
			"status":"Operatinoal",
		})
	})

	port := os.Getenv("PORT")
	if port == ""{
		port = "8080"
	}

	log.Printf("[Storefronts] HTTP Server listerning on : %s", port)
	if err := r.Run(":"+port); err !=nil {
		log.Fatalf("Server startup failed: %v", err)
	}
}