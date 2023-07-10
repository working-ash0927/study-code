package main

import (
	"math/rand"
	"net/http"
	"os"
	"strconv"
)

func main() {
	// http.HandleFunc("/hello", func(w http.ResponseWriter, req *http.Request) {
	// 	w.Write([]byte("Hello World"))
	// })
	http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
		randomInt := rand.Intn(101)
		a := strconv.Itoa(randomInt)
		w.Write([]byte(a))
	})
	http.HandleFunc("/hostname", func(w http.ResponseWriter, req *http.Request) {
		hostname, err := os.Hostname()
		if err != nil {
			return
		}
		w.Write([]byte(hostname))
	})

	http.ListenAndServe(":80", nil)
}
