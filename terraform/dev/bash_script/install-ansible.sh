#!/bin/bash
curl https://bootstrap.pypa.io/get-pip.py -o /root/get-pip.py
python3 /root/get-pip.py
pip3 install ansible
apt update -y
# 원격 접속
apt install -y sshpass 
# hosts 파일(Inventory) 정의
mkdir -p /etc/ansible
# -t all 주면 모든 옵션 주석되있는 설정샘플 생성됨.
ansible-config init --disabled -t all > /root/ansible.cfg