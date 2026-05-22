package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/gin-contrib/cors"
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

	corsConfig := cors.Config{
		AllowOrigins: []string{
			"http://localhost:5173",
			"http://127.0.0.1:5173",
		},
		AllowMethods: []string{"GET","POST","PUT","DELETE","PATCH","OPTIONS"},
		AllowHeaders : []string{"Origin","Content-Type","Accept","Authorization"},
		ExposeHeaders: []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge: 12*time.Hour,
	}

	r.Use(cors.New(corsConfig))
	log.Println("[Storefronts] CORS middleware configured with credential support")
	r.Use(middleware.RequestLogger())

	// public routes  - no authorization required
	r.GET("/health", (&handler.HealthHandler{}).Check)

	// auth endpoints (login/logou/me) - public but rate limited in production
	authHandler := &handler.AuthHandler{
		Pool : pool,
		JWTSecret: cfg.JWTSecret,
		Domain: "localhost", // set to .storefronts.com in production
	}
	auth := r.Group("/api/v1/auth")
	auth.POST("/login", authHandler.Login)
	auth.POST("/logout", authHandler.Logout)
	auth.GET("/me", middleware.JWTAuth(cfg.JWTSecret), authHandler.Me)

	// protected routes (jwt+tenant context required)
	authGroup := r.Group("/api/v1")
	authGroup.Use(middleware.JWTAuth(cfg.JWTSecret)) // validate cookier or header 

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
	log.Println("[Storefronts] Shutdown signal received")

	shutDownCtx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err :=srv.Shutdown(shutDownCtx); err != nil {
		log.Println("[Storefronts] Server forced to shutdonw: %w", err)
	}
	log.Println("[Storefronts] Server shut down gracefully")

}