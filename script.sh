#!/bin/bash

sudo apt-get update -y
sudo apt-get install docker.io -y
sudo systemctl start docker
sudo usermod -a -G docker $USER
sudo systemctl enable docker
sudo curl -L 'https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)' -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo sysctl -w vm.max_map_count=262144
sudo docker run -p 80:9090 -d sashapo12/project:latest
