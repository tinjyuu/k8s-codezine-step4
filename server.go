package main

import (
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "my-api-v10")
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":80", nil)
}
