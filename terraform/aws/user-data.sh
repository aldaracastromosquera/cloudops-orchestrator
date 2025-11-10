#!/bin/bash
set -euxo pipefail


# Actualiza e instala Docker y Compose
apt-get update -y
apt-get install -y docker.io docker-compose-plugin git
systemctl enable --now docker


# Clona el repo y levanta el stack
rm -rf /opt/cloudops || true
mkdir -p /opt
cd /opt


git clone "${github_repo_url}" cloudops
cd cloudops


# Primer arranque
/usr/bin/docker compose pull || true
/usr/bin/docker compose up -d


# Arranque persistente en reboot con systemd unit sencillo
cat >/etc/systemd/system/cloudops.service <<'UNIT'
[Unit]
Description=CloudOps Orchestrator Compose Stack
After=docker.service
Requires=docker.service


[Service]
Type=oneshot
WorkingDirectory=/opt/cloudops
ExecStart=/usr/bin/docker compose up -d
RemainAfterExit=yes


[Install]
WantedBy=multi-user.target
UNIT


systemctl daemon-reload
systemctl enable cloudops.service