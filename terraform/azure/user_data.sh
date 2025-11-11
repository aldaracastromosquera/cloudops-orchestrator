#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

LOG="/var/log/cloudops-init.log"
exec > >(tee -a "$LOG") 2>&1

echo "[1/6] Paquetes base…"
apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release git

echo "[2/6] Docker repo oficial…"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
UBUNTU_CODENAME="$(. /etc/os-release && echo "$UBUNTU_CODENAME")"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable" \
> /etc/apt/sources.list.d/docker.list
apt-get update -y

echo "[3/6] Instalando Docker + Compose…"
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker

# (Opcional) Abrir firewall del SO si estuviera activo
if command -v ufw >/dev/null 2>&1; then
ufw allow 22/tcp || true
ufw allow 80/tcp || true
ufw allow 443/tcp || true
fi

echo "[4/6] Recuperando proyecto…"
rm -rf /opt/cloudops || true
git clone https://github.com/aldaracastromosquera/cloudops-orchestrator.git /opt/cloudops

# Si tienes .env.example, crea .env si no existe
if [ -f /opt/cloudops/.env.example ] && [ ! -f /opt/cloudops/.env ]; then
cp /opt/cloudops/.env.example /opt/cloudops/.env
fi

# Asegurar que exista una config de Nginx válida
if [ ! -f /opt/cloudops/nginx/default.conf ]; then
mkdir -p /opt/cloudops/nginx
cat >/opt/cloudops/nginx/default.conf <<'NGINX'
server {
listen 80;
server_name _;
location / {
proxy_pass http://app:8000;
proxy_http_version 1.1;
proxy_set_
