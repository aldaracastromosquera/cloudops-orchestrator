# CloudOps Orchestrator

## 🇪🇸 Español

CloudOps Orchestrator es una solución completa de despliegue y monitorización construida con **Flask**, **Docker Compose**, **PostgreSQL**, **Nginx**, **Prometheus** y **Grafana**. Incluye además automatización opcional de infraestructura mediante **Terraform** y **Azure**, así como un flujo CI/CD mediante **GitHub Actions**.

---

## Características

* Backend contenedorizado con **Flask**
* Proxy inverso con **Nginx**
* Base de datos persistente con **PostgreSQL**
* Exportación de métricas en formato Prometheus
* Dashboards automáticos con **Grafana**
* Métricas del sistema y contenedores mediante **Node Exporter** y **cAdvisor**
* Despliegue opcional en **Microsoft Azure** mediante **Terraform**
* Pipeline CI/CD opcional usando **GitHub Actions**

---

## Estructura del Proyecto

```
cloudops-orchestrator/
├── app/
│   ├── main.py                     # Aplicación Flask
│   ├── Dockerfile                  # Imagen del backend
│   ├── requirements.txt            # Dependencias Python
│   └── .env.example                # Variables de entorno
│
├── nginx/
│   ├── default.conf                # Proxy inverso hacia Flask
│
├── prometheus/
│   ├── prometheus.yml              # Configuración de scraping
│
├── grafana/
│   └── provisioning/
│       ├── datasources/
│       │   └── prometheus.yml      # Datasource Prometheus
│       └── dashboards/
│           ├── dashboards.yml      # Provisionamiento de dashboards
│           └── cloudops-dashboard.json   # Dashboard principal
│
├── terraform/
│   └── azure/
│       ├── main.tf                 # Recursos Azure (VM, VNet, NSG…)
│       ├── variables.tf            # Variables Terraform
│       ├── outputs.tf              # IP pública, nombre VM…
│       ├── user_data.sh            # Cloud-init (instala Docker + app)
│
├── docs/
│   ├── azure-deployment.md         # Guía completa de despliegue en Azure
│   ├── architecture.md             # Arquitectura de la plataforma
│   ├── monitoring.md               # Monitorización (Prometheus/Grafana)
│   └── cicd.md                     # CI/CD con GitHub Actions
│
├── .github/
│   └── workflows/
│       ├── deploy.yml              # Despliegue automático a Azure por 
│
├── docker-compose.yml              # Orquestación completa del stack
├── README.md                       # README principal (inglés)
├── LICENSE                         # MIT License
├── Makefile                        # Comandos útiles (opcional)
├── .gitignore                      # Ignorar archivos
└── .dockerignore                   # Ignorar archivos en builds Docker

```

Para documentación detallada de cada módulo, revisa los archivos dentro de [docs/].(./docs)

---

## Documentación

Toda la documentación extendida se encuentra en:

➡ [docs/README-AZURE.md](./docs/README-azure.md) — Terraform, provisión de la VM, cloud-init, monitorización, PromQL, rutas

➡ [docs/architecture.md](./docs/arquitecture.md) — Componentes del sistema, servicios Docker, pipeline de métricas, diagramas

---

## Autor
**Aldara Castro Mosquera**  
*Cloud & DevOps Enthusiast*  
Galicia, España  

---

## ⚠️ Licencia
Consulta el archivo [LICENSE](./LICENSE) para más detalles.

══════════════════════════════════════════════════════════════════════════

## 🇬🇧 English

CloudOps Orchestrator is a fully automated deployment and monitoring solution built with **Flask**, **Docker Compose**, **PostgreSQL**, **Nginx**, **Prometheus**, and **Grafana**. It includes optional infrastructure automation using **Terraform** and **Azure**, as well as CI/CD integration with **GitHub Actions**.

---

## Features

* Containerized backend with **Flask**
* Reverse proxy using **Nginx**
* Persistent storage using **PostgreSQL**
* Metrics exported via **Prometheus** format
* Dashboards provided by **Grafana**
* System- and container-level metrics via **Node Exporter** and **cAdvisor**
* Optional **Azure deployment** automated with **Terraform**
* Optional **GitHub Actions CI/CD** deployment pipeline

---

## Project Structure

```
cloudops-orchestrator/
├── app/
│   ├── main.py                     # Flask application
│   ├── Dockerfile                  # Backend Docker image
│   ├── requirements.txt            # Python dependencies
│   └── .env.example                # Environment variables template
│
├── nginx/
│   ├── default.conf                # Reverse proxy configuration for Flask
│
├── prometheus/
│   ├── prometheus.yml              # Scraping configuration
│
├── grafana/
│   └── provisioning/
│       ├── datasources/
│       │   └── prometheus.yml      # Prometheus datasource definition
│       └── dashboards/
│           ├── dashboards.yml      # Dashboard provisioning config
│           └── cloudops-dashboard.json   # Main Grafana dashboard
│
├── terraform/
│   └── azure/
│       ├── main.tf                 # Azure resources (VM, VNet, NSG…)
│       ├── variables.tf            # Terraform variables
│       ├── outputs.tf              # Public IP, VM name…
│       ├── user_data.sh            # Cloud-init script (Docker + app setup)
│
├── docs/
│   ├── azure-deployment.md         # Full Azure deployment guide
│   ├── architecture.md             # Platform architecture
│   ├── monitoring.md               # Monitoring (Prometheus/Grafana)
│   └── cicd.md                     # GitHub Actions CI/CD pipeline
│
├── .github/
│   └── workflows/
│       ├── deploy.yml              # Automatic deployment to Azure via SSH
│
├── docker-compose.yml              # Full stack orchestration
├── README.md                       # Main README (English)
├── LICENSE                         # MIT License
├── Makefile                        # Useful commands (optional)
├── .gitignore                      # Git ignore rules
└── .dockerignore                   # Ignore rules for Docker builds

```

For in‑depth documentation for terraform module, refer to the corresponding files inside [docs/](./docs).

---

## Documentation

To avoid duplication and improve navigation, all extended guides have been moved to:

➡ [docs/README-AZURE.md](./docs/README-azure.md) — Terraform, VM provisioning, cloud-init, monitoring stack, PromQL, and routes

➡ [docs/architecture.md](./docs/arquitecture.md) — System components, Docker services, metrics pipeline, diagrams

---

## Author
**Aldara Castro Mosquera**  
*Cloud & DevOps Enthusiast*  
Galicia, Spain  

---

## ⚠️ License
See the [LICENSE](./LICENSE) file for more details.