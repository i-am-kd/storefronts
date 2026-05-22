package middleware

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/i-am-kd/storefronts/internal/context"
)

func JWTAuth(jwtSecret string) gin.HandlerFunc{
	return func (c *gin.Context){
		var tokenStr string 

		// check httponly cookie 
		cookie, err := c.Cookie("storefronts_token")
		if err == nil {
			tokenStr = cookie
		}else{
			// fallback to authorization header 
			authHeader := c.GetHeader("Authorization")
			if authHeader ==""{
				c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error":"missing credentials"})
				return 
			}
			tokenStr = strings.TrimPrefix(authHeader, "Bearer ")
		}
		token, err := jwt.Parse(tokenStr, func(t *jwt.Token) (interface{}, error){
			if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, jwt.ErrSignatureInvalid
			}
			return []byte(jwtSecret), nil
		})

		if err != nil || !token.Valid {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error":"Invalid or expired token"})
			return
		}

		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error":"invalid token claims"})
			return
		}

		storeID, ok := claims["store_id"].(string)
		if !ok || storeID==""{
			c.AbortWithStatusJSON(http.StatusForbidden, gin.H{"error":"tenant claim missing"})
			return 
		}

		c.Set(string(context.StoreIDKey), storeID)
		c.Next()
	}
}