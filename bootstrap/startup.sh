#!/usr/bin/bash
set -euxo pipefail

exec > >(tee /var/log/joelslab-startup.log) 2>&1

dnf install -y dnf-plugins-core git curl

dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker

rm -rf /opt/lab
git clone https://github.com/j0bert95/joelslab.git /opt/lab

cat > /etc/systemd/system/joelslab-compose.service <<'EOF'
[Unit]
Description=Joel's Docker Compose Lab
Requires=docker.service
After=docker.service network-online.target
Wants=network-online.target

[Service]
Type=oneshot
WorkingDirectory=/opt/lab/docker
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable joelslab-compose.service
systemctl start joelslab-compose.service

docker ps