package main

import (
	"log"

	"github.com/gofiber/fiber/v2"
)

type HealthResponse struct {
	Message string `json:"message"`
}

func main() {
	app := fiber.New()

	app.Get("/health", func(c *fiber.Ctx) error {
		return c.JSON(HealthResponse{Message: "healthy"})
	})

	log.Fatal(app.Listen(":3000"))
}
