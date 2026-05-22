package handler

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"golang.org/x/crypto/bcrypt"
)

type AuthHandler struct {
	Pool *pgxpool.Pool
	JWTSecret string 
	Domain string 
}

type LoginRequest struct{
	Email string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=8"`
}

func (h *AuthHandler) Login(c *gin.Context){
	var req LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error":"invalid request paylod"})
		return 
	}

	var storeID string
	var hash string 
	err := h.Pool.QueryRow(c.Request.Context(),
		"SELECT store_id, password_hash FROM stores WHERE email = $1", req.Email).Scan(&storeID, &hash)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error":"invalid credential"})
		return
	}

	if err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(req.Password)); err != nil{
		c.JSON(http.StatusUnauthorized, gin.H{"error":"invalid credentials"})
		return
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"store_id": storeID,
		"role": "admin",
		"exp": time.Now().Add(4 *time.Hour).Unix(),
		"iat": time.Now().Unix(),
	})

	tokenStr, err := token.SignedString([]byte(h.JWTSecret))
	if err != nil{
		c.JSON(http.StatusInternalServerError, gin.H{"error":"token generation failed"})
		return
	}
// production safe cookie 
	cookie := &http.Cookie{
		Name: 		"storefronts_token",
		Value: 			tokenStr,
		Path: 			  "/",
		Domain: 	  h.Domain,
		MaxAge: 	86400,
		HttpOnly:    true,
		Secure:			 false,
		SameSite: 	   http.SameSiteLaxMode,
	}

	http.SetCookie(c.Writer, cookie)

	c.JSON(http.StatusOK, gin.H{"message":"authenticated", "store_id":storeID})
}

func (h *AuthHandler) Logout(c *gin.Context){
	cookie := &http.Cookie{
		Name: "storefronts_token",
		Value: "",
		Path: "/",
		Domain: h.Domain,
		MaxAge: -1,
		HttpOnly: true,
		Secure: false,
		SameSite: http.SameSiteLaxMode,
	}

	http.SetCookie(c.Writer, cookie)
	c.JSON(http.StatusOK, gin.H{"message":"logged out"})
}

func (h *AuthHandler) Me(c *gin.Context){
	storeID, _ := c.Get("store_id")
	c.JSON(http.StatusOK, gin.H{"store_id":storeID, "role":"admin"})
}