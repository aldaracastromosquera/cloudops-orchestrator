# Comandos abreviados para agilizar acciones comunes en el proyecto


# ------------------------------------------------------------
# Define el intérprete de comandos que se usará
# ------------------------------------------------------------
# Forzamos a que los comandos se ejecuten con bash (no sh)
SHELL := /bin/bash


# ------------------------------------------------------------
# Declaramos las tareas "phony" (que no corresponden a archivos)
# ------------------------------------------------------------
.PHONY: up down logs ps fmt lint
# Esto indica a Make que estas tareas no son archivos,
# sino comandos que deben ejecutarse siempre que se invoquen.


# Construye y levanta todos los servicios definidos en docker-compose.yml
# 	-d → modo “detached” (en segundo plano)
# 	--build → fuerza la reconstrucción de las imágenes
up:
docker compose up -d --build


# Muestra los últimos 100 registros de todos los contenedores
# 	-f → sigue los logs en tiempo real (como “tail -f”)
logs:
docker compose logs -f --tail=100


# Lista el estado actual de los contenedores (nombre, puerto, estado, etc.)
ps:
docker compose ps


# Detiene y elimina todos los contenedores, redes y volúmenes asociados
# 	-v → también elimina los volúmenes (como la base de datos)
down:
docker compose down -v


# Formatea los archivos de Terraform en terraform/azure/
fmt:
terraform -chdir=terraform/azure fmt


# Valida la sintaxis y estructura de los archivos Terraform
lint:
terraform -chdir=terraform/azure validate