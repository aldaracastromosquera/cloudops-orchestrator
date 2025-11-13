# CloudOps Orchestrator — Architecture (English & Spanish)
# 🇪🇸 Resumen de Arquitectura

CloudOps Orchestrator utiliza una **arquitectura modular basada en contenedores**, diseñada para ser totalmente reproducible, escalable y automatizable. Esta sección describe cada componente y cómo interactúan entre sí.

---

## Componentes Principales

### 1. **Backend Flask (app/)**

* Expone endpoints:

  * `/` ruta principal
  * `/health` estado del servicio
  * `/metrics` exportación Prometheus
* Construido en una imagen ligera de Python
* Se comunica internamente con PostgreSQL

### 2. **Proxy Inverso Nginx (nginx/)**

* Recibe el tráfico HTTP en el puerto **80**
* Redirige peticiones al backend en **8000**
* Agrega seguridad y desacopla los servicios

### 3. **Base de Datos PostgreSQL**

* Guarda la información persistente de la aplicación
* Usa volúmenes Docker para almacenamiento seguro
* No es accesible desde el exterior

---

## Stack de Monitorización

### 4. **Prometheus**

* Recolecta métricas desde:

  * Flask `/metrics`
  * Node Exporter
  * cAdvisor

### 5. **Grafana**

* Paneles y datasources preconfigurados
* Interfaz para analizar el estado de la plataforma

### 6. **Node Exporter**

* Proporciona métricas del host:

  * CPU
  * RAM
  * Disco
  * Carga del sistema

### 7. **cAdvisor**

* Métricas por contenedor:

  * CPU
  * Memoria
  * Uso de disco

---

## Orquestación con Docker Compose

Define redes, volúmenes, dependencias y salud del sistema.

Servicios:

* app
* nginx
* db
* prometheus
* grafana
* node_exporter
* cadvisor

---

## Infraestructura Azure (Terraform)

Terraform despliega:

* Grupo de recursos
* Red virtual
* Subred
* NSG con reglas necesarias
* IP pública
* Máquina virtual Ubuntu

El script `user_data.sh` automatiza:

* Instalación de Docker
* Clonado del repositorio
* Levantamiento del stack

La VM queda **autosuficiente**.

---

## Arquitectura CI/CD

GitHub Actions ejecuta:

* Pull de cambios
* Reconstrucción de contenedores
* Redeploy automático

---

## Diagrama de Arquitectura 

```
               ┌─────────────────────┐
               │      Azure VM       │
               │ (Ubuntu + Docker)   │
               └──────────┬──────────┘
                          │
               ┌──────────▼──────────┐
               │    Red Docker       │
               └──────────┬──────────┘
                          │
     ┌────────────────────┼──────────────────────┐
     │                    │                      │
┌────▼─────┐        ┌─────▼─────┐        ┌──────▼──────┐
│  Nginx   │        │  Flask    │        │ PostgreSQL  │
│   :80    │        │   :8000   │        │    :5432    │
└──────────┘        └───────────┘        └─────────────┘
                          │
              ┌───────────┼─────────────────────────────┐
              │           │                             │
       ┌──────▼─────┐ ┌───▼──────────┐          ┌───────▼──────┐
       │ Prometheus │ │   Grafana    │          │   cAdvisor   │
       │    :9090   │ │    :3000     │          │    :8081     │
       └────────────┘ └──────────────┘          └──────────────┘
                          │
                    ┌─────▼─────┐
                    │NodeExport │
                    │   :9100   │
                    └───────────┘
```

---

## Autor
**Aldara Castro Mosquera**  
*Cloud & DevOps Enthusiast*  
Galicia, España  

---

## ⚠️ Licencia
Consulta el archivo [LICENSE](./LICENSE) para más detalles.

══════════════════════════════════════════════════════════════════════════

# 🇬🇧 Architecture Overview

CloudOps Orchestrator follows a **modular, container-based architecture** designed for clarity, security, and full automation. The system integrates application logic, reverse proxying, persistent storage, monitoring, and infrastructure provisioning.

This document provides a complete overview of how the platform is structured and how each component interacts.

---

## Core Components

### 1. **Flask Backend (app/)**

* Exposes HTTP endpoints:

  * `/` main route
  * `/health` health check
  * `/metrics` Prometheus exporter
* Built into a lightweight Python Docker image
* Connects internally to PostgreSQL

### 2. **Nginx Reverse Proxy (nginx/)**

* Accepts all incoming traffic on port **80**
* Forwards requests to the Flask container (port **8000**)
* Ensures security and performance isolation

### 3. **PostgreSQL Database**

* Stores application data
* Persisted using Docker volumes
* Only available inside the Docker network

---

## Monitoring Stack

### 4. **Prometheus**

* Scrapes metrics from:

  * Flask app (`/metrics`)
  * Node Exporter
  * cAdvisor
* Stores time-series metrics (retention configurable)

### 5. **Grafana**

* Automatically provisioned datasource (Prometheus)
* Automatically provisioned dashboards
* UI for visualizing performance and system health

### 6. **Node Exporter**

* Provides metrics for the host system:

  * CPU
  * RAM
  * Disk usage
  * System load

### 7. **cAdvisor**

* Provides container-level metrics:

  * CPU per container
  * Memory
  * Filesystem usage

---

## Container Orchestration

All components run under a single Docker Compose configuration that defines:

* Networking
* Dependencies
* Volumes
* Healthchecks
* Automatic provisioning

Services include:

* `app`
* `nginx`
* `db`
* `prometheus`
* `grafana`
* `node_exporter`
* `cadvisor`

---

## Azure Infrastructure (Terraform)

When deployed in Azure:

* Terraform creates:

  * Resource Group
  * Virtual Network
  * Subnet
  * Network Security Group (NSG)
  * Public IP
  * Ubuntu Virtual Machine
* Cloud-init (`user_data.sh`) fully configures the VM:

  * Installs Docker
  * Clones the repo to `/opt/cloudops`
  * Starts Docker Compose automatically

The system becomes **self-provisioning**.

---

## CI/CD Architecture

GitHub Actions connects to the VM via SSH and performs:

* Code updates (git pull)
* Service rebuilds (`docker compose up -d --build`)
* Automatic redeployment of the entire stack

---

## Architecture Diagram (ASCII)

```
            ┌────────────────────┐
            │     Azure VM       │
            │  (Ubuntu + Docker) │
            └─────────┬──────────┘
                      │
             ┌────────▼────────┐
             │ Docker Network  │
             └────────┬────────┘
                      │
    ┌─────────────────┼─────────────────┐
    │                 │                 │
┌───▼──────┐    ┌─────▼──────┐    ┌─────▼──────┐
│  Nginx   │    │   Flask    │    │ PostgreSQL │
│  :80     │    │   :8000    │    │   :5432    │
└──────────┘    └────────────┘    └────────────┘
                      │
       ┌──────────────┼────────────────────────────┐
       │              │                            │
 ┌─────▼────┐   ┌─────▼────────┐           ┌───────▼──────┐
 │Prometheus│   │   Grafana    │           │  cAdvisor    │
 │  :9090   │   │    :3000     │           │    :8081     │
 └──────────┘   └──────────────┘           └──────────────┘
                      │
                 ┌────▼──────┐
                 │NodeExport.│
                 │   :9100   │
                 └───────────┘
```

---

## Author
**Aldara Castro Mosquera**  
*Cloud & DevOps Enthusiast*  
Galicia, Spain  

---

## ⚠️ License
See the [LICENSE](./LICENSE) file for more details.
