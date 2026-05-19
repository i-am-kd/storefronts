package config

import (
	"os"
	"strconv"
)

type AppConfig struct{
	Port string
	DBHost string
	DBPort string
	DBUser string
	DBPass string 
	DBName string
	DBSSL string
	JWTSecret string 
	JWTExpiry int
}

func Load() AppConfig{
	maxConns, _ := strconv.Atoi(os.Getenv("PG_MAX_CONNS"))
	if maxConns ==0{
		maxConns =20
	}

	return AppConfig{
		Port: getEnv("PORT", "8080"),
		DBHost : getEnv("DB_HOST", "localhost"),
		DBPort : getEnv("DB_PORT", "5432"),
		DBUser: getEnv("DB_USER", "postgres"),
		DBPass: os.Getenv("DB_PASSWORD"),
		DBName: getEnv("DB_NAME","storefronts"),
		DBSSL: getEnv("DB_SSLMODE", "disable"),
		JWTSecret: os.Getenv("JWT_SECRET"),
		JWTExpiry: 4,

	}
}

func getEnv(key, fallback string) string {
	if v := os.Getenv(key); v !="" {
		return v
	}
	return fallback
}