#!/bin/bash
while true; do
    status=$(echo $(kc get pods) | awk '{print $8}')
    echo $(kc get pods) | awk '{print $6 " " $7 " " $8}';
    while [[ $status != "Running" ]]; do
        # echo $status
        status=$(echo $(kc get pods) | awk '{print $8}')
        sleep 0.3;
    done
    echo $(kc delete pod --all);
done