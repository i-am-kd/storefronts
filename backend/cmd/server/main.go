package main 

import (
	"log"
	"context"
	"os/signal"
	"syscall"
	"net/http"
	"os"
	"time"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/i-am-kd/storefronts/internal/config"
	"github.com/i-am-kd/storefronts/internal/db"
	"github.com/i-am-kd/storefronts/internal/handler"
	"github.com/i-am-kd/storefronts/internal/middleware"
)

func main(){
	log.Println("[Storefronts] Initializing backend service...")

	ctx := context.Background()
	cfg := config.Load()
	fmt.Printf("DEBUG: host=%s port=%s user=%s db=%s pass=%s\n", 
    cfg.DBHost, cfg.DBPort, cfg.DBUser, cfg.DBName, 
    func() string { if cfg.DBPass != "" { return "SET" }; return "EMPTY" }())

	pool, err := db.NewPool(ctx, db.Config{
		Host: 			   cfg.DBHost,
		Port: 			 	 cfg.DBPort,
		User: 			    cfg.DBUser,
		Password: 	  cfg.DBPass,
		DBName: 	 cfg.DBName,
		SSLMode: 	cfg.DBSSL,
		MaxConns: 	int32(20),
	})

	if err != nil {
		log.Fatalf("Database Initialization failed: %v", err)
	}

	defer pool.Close()

	gin.SetMode(gin.ReleaseMode)
	r:= gin.New()
	r.Use(gin.Recovery())
	r.Use(middleware. CORS())
	r.Use(middleware.RequestLogger())

	// public routes 
	r.GET("/health", (&handler.HealthHandler{}).Check)

	//tenant authentical routes 
	authGroup := r.Group("/api/v1")
	authGroup.Use(middleware.JWTAuth(cfg.JWTSecret))

	//admin endpoints 
	admin := authGroup.Group("/admin")
	storeHandler := &handler.StoreHandler{Pool: pool}
	admin.GET("/inventory", storeHandler.GetInventory)

	//customer explore endpoints 
	// explore := authGroup.Group("/explore")

	srv := &http.Server{Addr: ":" + cfg.Port, Handler: r}
	go func(){
		log.Printf("[Storefronts] HTTP Server listerning on http://localhost:%s", cfg.Port)
		if err := srv.ListenAndServe(); err !=nil && err !=http.ErrServerClosed{
			log.Fatalf("Server startup failed: %v", err)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<- quit

	shutDownCtx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	srv.Shutdown(shutDownCtx)
	log.Println("[Storefronts] Server shut down gracefully")

}