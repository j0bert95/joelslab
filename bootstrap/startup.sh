#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/joelslab-startup.log) 2>&1

dnf install -y dnf-plugins-core git curl

dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker

rm -rf /opt/lab
git clone https://github.com/j0bert95/joelslab.git /opt/lab

cd /opt/lab/docker

docker compose up -d

docker ps