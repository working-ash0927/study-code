#!/bin/bash
trap "exit" SIGINT
mkdir /var/htdocs
SET=$(seq 0 9999)

for i in $SET; do
    # httpd 컨테이너의 경로
    echo "Running loop seq $i" > /var/htdocs/index.html
    sleep 10
done