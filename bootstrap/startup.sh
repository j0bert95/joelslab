#!/bin/bash

dnf update -y

dnf install -y git docker

systemctl enable docker
systemctl start docker

curl -L \
https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
-o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

git clone https://github.com/j0bert95/joelslab /opt/lab

cd /opt/lab/docker

docker compose up -d