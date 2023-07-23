#!/bin/bash
# helm 최신버전 설치
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# helm 명령어 자동완성
helm completion bash > /etc/bash_completion.d/helm
helm completion bash
source <(helm completion bash)

# bitnami 공식 리포 등록
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm repo list