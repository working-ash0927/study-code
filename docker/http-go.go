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

	// 정적 파일들이 있는 디렉토리 경로 설정
	staticDir := "/var/www/html"

	// 정적 파일 핸들러 생성
	staticHandler := http.FileServer(http.Dir(staticDir))

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// URI에 해당하는 정적 파일 서빙
		staticHandler.ServeHTTP(w, r)
	})

	http.HandleFunc("/rand", func(w http.ResponseWriter, req *http.Request) {
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
