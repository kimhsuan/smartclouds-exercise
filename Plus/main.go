package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// album represents data about a record album.
// type employeedata struct {
// 	ID       string `json:"id"`
// 	Email    string `json:"email"`
// 	Mobile   string `json:"mobile"`
// 	Position struct {
// 		Title      string `json:"title"`
// 		Department string `json:"department"`
// 	} `json:"position"`
// }

type employeedata struct {
	ID       string   `json:"id"`
	Email    string   `json:"email"`
	Mobile   string   `json:"mobile"`
	Position Position `json:"position"`
}
type Position struct {
	Title      string `json:"title"`
	Department string `json:"department"`
}

var employees = []employeedata{
	{ID: "username1", Email: "email1@email.com", Mobile: "0987654321", Position: Position{Title: "title", Department: "department"}},
	{ID: "username2", Email: "email2@email.com", Mobile: "0987654323", Position: Position{Title: "title", Department: "department"}},
	{ID: "username3", Email: "email3@email.com", Mobile: "0987654323", Position: Position{Title: "title", Department: "department"}},
}

func getEmployees(c *gin.Context) {
	c.IndentedJSON(http.StatusOK, employees)
}

// postEmployees adds an album from JSON received in the request body.
func postEmployees(c *gin.Context) {
	var newEmployee employeedata

	// Call BindJSON to bind the received JSON to
	// newEmployee.
	if err := c.BindJSON(&newEmployee); err != nil {
		return
	}

	// Add the new employee to the slice.
	employees = append(employees, newEmployee)
	c.IndentedJSON(http.StatusCreated, newEmployee)
}

// getEmployeeByID locates the album whose ID value matches the id
// parameter sent by the client, then returns that album as a response.
func getEmployeeByID(c *gin.Context) {
	id := c.Param("id")

	// Loop over the list of employees, looking for
	// an employee whose ID value matches the parameter.
	for _, a := range employees {
		if a.ID == id {
			c.IndentedJSON(http.StatusOK, a)
			return
		}
	}
	c.IndentedJSON(http.StatusNotFound, gin.H{"message": "employee not found"})
}

func putEmployeeByID(c *gin.Context) {
	var newEmployee employeedata

	// Call BindJSON to bind the received JSON to
	// newemployee.
	if err := c.BindJSON(&newEmployee); err != nil {
		return
	}

	// Add the new employee to the slice.
	employees = append(employees, newEmployee)
	c.IndentedJSON(http.StatusCreated, newEmployee)
}

func deleteEmployeeByID(c *gin.Context) {
	id := c.Param("id")

	for i, a := range employees {
		if a.ID == id {
			employees = append(employees[:i], employees[i+1:]...)
			return
		}
	}
	c.IndentedJSON(http.StatusNoContent, gin.H{"message": "employee not found"})
}

func main() {
	router := gin.Default()
	router.GET("/employees", getEmployees)
	router.GET("/employees/:id", getEmployeeByID)
	router.POST("/employees", postEmployees)
	router.PATCH("/employees/:id", putEmployeeByID)
	router.DELETE("/employees/:id", deleteEmployeeByID)
	router.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"message": "hello world"})
	})
	router.Run(":8080")
}
