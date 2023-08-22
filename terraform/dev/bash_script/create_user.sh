#!/bin/bash
username='ash'
sed -i '/PasswordAuthentication/c\PasswordAuthentication = yes' /etc/ssh/sshd_config
useradd -m -s /bin/bash "$username" -d /home/"$username"
echo "$username":'qweqweqwe' | chpasswd
# ec2-user랑 동일 권한 형태. 모든 sudo 권한에 패스워드를 물어보지 않는다.
echo "$username ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/10-username-"$username"
systemctl restart sshd