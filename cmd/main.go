package main

import (
	"log"

	"github.com/gin-gonic/gin"
)

func main() {
	log.Printf("starting server..")
	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})
	r.Run() // listen and serve on 0.0.0.0:8080
}
