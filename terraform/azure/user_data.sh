# Script que se ejecuta automáticamente al iniciar la VM en Azure para preparar el entorno y desplegar CloudOps Orchestrator dentro de una máquina virtual Ubuntu.

#!/bin/bash                   
set -e                                          # Hace que el script se detenga si ocurre cualquier error
export DEBIAN_FRONTEND=noninteractive           # Evita prompts interactivos durante apt-get


# ---------------------------
# Paquetes base necesarios
# ---------------------------
apt-get update -y                                 # Actualiza el índice de paquetes del sistema
apt-get install -y ca-certificates curl git gnupg # curl para descargar el GPG de Docker, git para clonar tu repositorio y gnupg para verificar firmas GPG de Docker

# ---------------------------------------------------
# Añadir el repositorio oficial de Docker (importante)
# Justificación: En Ubuntu 20.04 el paquete `docker-compose-plugin` no existe en los repos por defecto. En su lugar, se instala Docker directamente desde el repositorio oficial de Docker Inc.
# ---------------------------------------------------
install -m 0755 -d /etc/apt/keyrings                            # Crea la carpeta para las claves GPG si no existe
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \ |     
gpg --dearmor -o /etc/apt/keyrings/docker.gpg                   # Descarga y convierte la clave GPG a formato apt
chmod a+r /etc/apt/keyrings/docker.gpg                          # Da permisos de lectura al archivo de clave


# Detecta automáticamente la versión de Ubuntu (focal en nuestro caso) y genera la línea de repositorio correcta
. /etc/os-release
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable" \
> /etc/apt/sources.list.d/docker.list


# ---------------------------------------------------
# Instalar Docker, Compose y dependencias oficiales
# ---------------------------------------------------
apt-get update -y
apt-get install -y \
docker-ce \                 # Docker Engine Community Edition
docker-ce-cli \             # Cliente de Docker
containerd.io \             # Runtime por defecto
docker-buildx-plugin \      # BuildKit moderno (multiarch)
docker-compose-plugin       # Docker Compose v2 integrado

systemctl enable --now docker  # Activa y arranca el servicio Docker al inicio


# -------------------------------
# Clonar y desplegar la aplicación
# En otra version de user_data.sh fallaba con “No such file or directory /opt/cloudops” porque el repo no se había clonado correctamente.
# Ahora garantizamos que el directorio exista y esté limpio antes de clonar.
# -------------------------------
rm -rf /opt/cloudops                                                                        # Limpia cualquier intento previo de clonación
git clone https://github.com/aldaracastromosquera/cloudops-orchestrator.git /opt/cloudops   # Clona el repo

cd /opt/cloudops
docker compose up -d                                                                        # Lanza toda la app (db + app + nginx) en segundo plano


# ---------------------------------------------------
# Comprobaciones rápidas 
# Estos comandos no eran parte del original, pero sirven para dejar constancia en /var/log/cloud-init-output.log de que todo fue bien.
# Usamos “|| true” para que no interrumpan la ejecución aunque algo falle.
# ---------------------------------------------------
docker --version || true                    # Muestra la versión de Docker instalada
docker compose version || true              # Verifica la versión de Compose
docker ps || true                           # Lista los contenedores levantados
ss -tulpn | grep -E ':80|:8000' || true     # Comprueba que los puertos 80 y 8000 están en escucha
