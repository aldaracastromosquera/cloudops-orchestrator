#!/usr/bin/env bash
# cloud-init bootstrap para Ubuntu 20.04:
# - Instala Docker (repo oficial + GPG)
# - Instala docker compose plugin
# - Clona el repo público y levanta el stack
# - Deja un log en /var/log/cloudops-bootstrap.log

exec > >(tee -a /var/log/cloudops-bootstrap.log | logger -t cloudops-bootstrap -s 2>/dev/console) 2>&1
set -euo pipefail

echo "[1/6] Actualizando e instalando prerequisitos…"
apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release git

echo "[2/6] Configurando clave GPG y repo oficial de Docker…"
install -m 0755 -d /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor \ -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
fi

UBUNTU_CODENAME="$(. /etc/os-release && echo "$UBUNTU_CODENAME")"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable" \
> /etc/apt/sources.list.d/docker.list

apt-get update -y

echo "[3/6] Instalando Docker Engine, Buildx y Compose…"
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker

echo "[4/6] Clonando el repositorio…"
REPO_URL="${REPO_URL:-https://github.com/aldaracastromosquera/cloudops-orchestrator.git}"
rm -rf /opt/cloudops || true
git clone "$REPO_URL" /opt/cloudops

echo "[5/6] Levantando Docker Compose…"
cd /opt/cloudops
docker compose up -d

echo "[6/6] Comprobaciones…"
docker compose ps
curl -s -i http://localhost/ | head -n1 || true
curl -s http://localhost/health || true
ss -tulpn | grep -E ':80|:8000' || true

echo "BOOTSTRAP OK"
