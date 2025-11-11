#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

LOG="/var/log/cloudops-init.log"
exec > >(tee -a "$LOG") 2>&1

echo "[1/7] Instalando paquetes base..."
apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release git

echo "[2/7] Añadiendo repositorio oficial de Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
UBUNTU_CODENAME="$(. /etc/os-release && echo "$UBUNTU_CODENAME")"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable" > /etc/apt/sources.list.d/docker.list
apt-get update -y

echo "[3/7] Instalando Docker + Docker Compose..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker

# Añade usuarios comunes al grupo docker si existen
for U in cloudops ubuntu azureuser; do
  id "$U" >/dev/null 2>&1 && usermod -aG docker "$U" || true
done

echo "[4/7] Clonando código del proyecto..."
rm -rf /opt/cloudops || true
git clone https://github.com/aldaracastromosquera/cloudops-orchestrator.git /opt/cloudops
cd /opt/cloudops

# .env por defecto si no existe
[ -f .env ] || { [ -f .env.example ] && cp .env.example .env || true; }

echo "[5/7] Configurando Nginx (si no existe)..."
mkdir -p nginx
cat > nginx/default.conf <<'NGINX'
server {
  listen 80;
  server_name _;

  location / {
      proxy_pass http://app:8000;
      proxy_http_version 1.1;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }

  location /health  { proxy_pass http://app:8000/health;  }
  location /metrics { proxy_pass http://app:8000/metrics; }
}
NGINX

echo "[6/7] Esperando a que Docker esté disponible..."
for i in {1..10}; do
    if command -v docker >/dev/null 2>&1; then
        echo "Docker disponible ✅"
        break
    else
        echo "Esperando Docker... ($i/10)"
        sleep 5
    fi
done

echo "[6/7] Levantando stack Docker..."
systemctl restart docker || true
docker info || (echo "Docker sigue sin funcionar ❌" && exit 1)
docker compose pull || true
docker compose up -d --build

echo "[7/7] Comprobaciones finales..."
for i in {1..30}; do
    ss -tulpn | grep -q ':80 ' && break
    sleep 3
done

docker compose ps
curl -sS -i http://localhost/ | head -n1 || true
curl -sS http://localhost/health || true
ss -tulpn | grep -E ':80|:8000' || true

echo "✅ Despliegue completado con éxito"
