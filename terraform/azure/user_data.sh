# Script que se ejecuta automáticamente al iniciar la VM

#!/bin/bash

set -e  # Detener ejecución si ocurre un error

# Actualizar el sistema
apt update -y

# Instalar dependencias necesarias
apt install -y docker.io docker-compose-plugin git

# Clonar el repositorio del proyecto
git clone https://github.com/aldaracastromosquera/cloudops-orchestrator.git /opt/cloudops

# Acceder al proyecto y levantar los servicios
cd /opt/cloudops
docker compose up -d
