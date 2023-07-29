#!/bin/bash
# swap 중지. 컨테이너 성능 저하 원인
sudo swapoff -a && sudo sed -i '/swap/s/^/#/' /etc/fstab
sudo free -m #swap 메모리가 0인지 확인

sudo tee /etc/modules-load.d/containerd.conf << EOF 
br_netfilter
overlay
EOF

modprobe overlay
modprobe br_netfilter

# 오버레이 네트워크와 포워딩 구성을 위함
sudo tee /etc/sysctl.d/99-kubernetes-cri.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# sudo systemctl stop firewalld
# sudo systemctl disable firewalld
## 호스트 서버 아키텍처 체크
arch_check=$(uname -m)
if [[ $arch_check == "x86_64" ]]; then
  myarch="amd64"
elif [[ $arch_check == "aarch64" ]]; then
  myarch="arm64"
fi

## 참고주소
# https://github.com/containerd/containerd/blob/main/docs/getting-started.md

## install Containerd
wget https://github.com/containerd/containerd/releases/download/v1.7.2/containerd-1.7.2-linux-$myarch.tar.gz
sudo tar zxvf containerd-1.7.2-linux-$myarch.tar.gz -C /usr/local/

## Containerd 데몬 프로세스 등록. 
sudo tee /etc/systemd/system/containerd.service << EOF 
# Copyright The containerd Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target local-fs.target

[Service]
#uncomment to enable the experimental sbservice (sandboxed) version of containerd/cri integration
#Environment="ENABLE_CRI_SANDBOXES=sandboxed"
ExecStartPre=-/sbin/modprobe overlay
ExecStart=/usr/local/bin/containerd

Type=notify
Delegate=yes
KillMode=process
Restart=always
RestartSec=5
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNPROC=infinity
LimitCORE=infinity
LimitNOFILE=infinity
# Comment TasksMax if your systemd version does not supports it.
# Only systemd 226 and above support this version.
TasksMax=infinity
OOMScoreAdjust=-999

[Install]
WantedBy=multi-user.target
EOF

# service containerd start
systemctl daemon-reload
systemctl enable --now containerd

# install cni plugin 
wget https://github.com/opencontainers/runc/releases/download/v1.1.7/runc.$myarch
install -m 755 runc.$myarch /usr/local/sbin/runc

# runtime을 systemd로 변경
mkdir /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
service containerd restart

# kubeadm 및 구성요소 설치
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# "centos, ubuntu, debian, amzn, ..."
mylinuxos=`awk -F= '/^ID=/{print $2}' /etc/os-release | sed 's/\"//'g`
if [ "$mylinuxos" = "centos" ] || [ "$mylinuxos" = "amzn" ]; then
    echo "im centos base"
    sudo yum install -y bash-completion
elif [ "$mylinuxos" = "ubuntu" ] || [ "$mylinuxos" = "debian" ]; then
    echo "im Ubuntu"
    sudo apt update -y
#    sudo apt upgrade -y
    sudo apt install -y bash-completion
else
  echo "im not fine"
  exit 1
fi

source /usr/share/bash-completion/bash_completion
# 명령어 간소화 목적
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'alias kc="/usr/bin/kubectl"' >>  ~/.bashrc
echo 'complete -o default -F __start_kubectl kc' >>  ~/.bashrc
source  ~/.bashrc

