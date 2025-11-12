#!/usr/bin/env bash
# Se asegura de que se ejecute con bash (no sh) y que cualquier error detenga la ejecución.
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive  # Evita prompts interactivos en apt

# Ruta del log donde guardaremos toda la salida del proceso.
LOG="/var/log/cloudops-init.log"
# Redirige stdout y stderr al log y también a la consola.
exec > >(tee -a "$LOG") 2>&1

echo "[1/7] Instalando paquetes base..."
# Actualiza los repositorios e instala utilidades básicas necesarias.
apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release git

echo "[2/7] Añadiendo repositorio oficial de Docker..."
# Crea el directorio donde se guardará la clave GPG de Docker.
install -m 0755 -d /etc/apt/keyrings
# Descarga y almacena la clave GPG del repositorio oficial de Docker.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Detecta el nombre del release de Ubuntu (ej. jammy, focal...).
UBUNTU_CODENAME="$(. /etc/os-release && echo "$UBUNTU_CODENAME")"
# Añade el repositorio estable de Docker a las fuentes de apt.
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable" > /etc/apt/sources.list.d/docker.list
apt-get update -y

echo "[3/7] Instalando Docker + Docker Compose..."
# Instala Docker Engine, CLI, containerd y el plugin de Compose v2.
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Habilita Docker para que arranque automáticamente al inicio.
systemctl enable --now docker

# Añade al grupo 'docker' los usuarios más comunes en imágenes de Azure/Ubuntu.
for U in cloudops ubuntu azureuser; do
id "$U" >/dev/null 2>&1 && usermod -aG docker "$U" || true
done

echo "[4/7] Clonando código del proyecto..."
# Elimina posibles restos de despliegues anteriores.
rm -rf /opt/cloudops || true
# Clona el repositorio con el código de la aplicación.
git clone https://github.com/aldaracastromosquera/cloudops-orchestrator.git /opt/cloudops
cd /opt/cloudops

# Si no existe un archivo .env, copia el .env.example para usar valores por defecto.
[ -f .env ] || { [ -f .env.example ] && cp .env.example .env || true; }

echo "[5/7] Configurando Nginx (si no existe)..."
# Crea la carpeta de configuración y genera un archivo default.conf básico.
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
# Espera hasta 50 segundos (10 intentos de 5s) a que Docker esté operativo.
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
# Reinicia Docker por si el daemon no se levantó del todo.
systemctl restart docker || true
# Comprueba que Docker responde correctamente antes de continuar.
docker info || (echo "---> Docker sigue sin funcionar" && exit 1)
# Descarga las imágenes necesarias (si existen en remoto).
docker compose pull || true
# Construye y levanta los servicios definidos en docker-compose.yml.
docker compose up -d --build

echo "[7/7] Comprobaciones finales..."
# Espera hasta 90s a que el puerto 80 esté escuchando.
for i in {1..30}; do
    ss -tulpn | grep -q ':80 ' && break
    sleep 3
done

# Muestra el estado de los contenedores y hace comprobaciones básicas HTTP.
docker compose ps
curl -sS -i http://localhost/ | head -n1 || true
curl -sS http://localhost/health || true
# Lista los puertos en uso (para verificar que 80 y 8000 están abiertos).
ss -tulpn | grep -E ':80|:8000' || true

echo "---> Despliegue completado con éxito"

