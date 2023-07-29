#!/bin/bash
sudo yum install -y docker
sudo usermod -aG docker ec2-user
sudo service docker start
sudo systemctl enable docker