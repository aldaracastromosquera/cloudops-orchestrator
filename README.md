# CloudOps Orchestrator

## 🇪🇸 Español

# CloudOps Orchestrator

CloudOps Orchestrator is a fully automated deployment and monitoring solution built with **Flask**, **Docker Compose**, **PostgreSQL**, **Nginx**, **Prometheus**, and **Grafana**. It includes optional infrastructure automation using **Terraform** and **Azure**, as well as CI/CD integration with **GitHub Actions**.

This README provides a high‑level overview of the project. The detailed deployment guides, architecture explanations, and monitoring documentation have been moved to the `docs/` directory for clarity and maintainability.

---

## 🚀 Features

* Containerized backend with **Flask**
* Reverse proxy using **Nginx**
* Persistent storage using **PostgreSQL**
* Metrics exported via **Prometheus** format
* Dashboards provided by **Grafana**
* System- and container-level metrics via **Node Exporter** and **cAdvisor**
* Optional **Azure deployment** automated with **Terraform**
* Optional **GitHub Actions CI/CD** deployment pipeline

---

## 📁 Project Structure

```
cloudops-orchestrator/
├─ app/             # Flask backend
├─ nginx/           # Reverse proxy configuration
├─ prometheus/      # Prometheus config
├─ grafana/         # Datasources & dashboards provisioning
├─ terraform/       # Full Azure deployment module
├─ docs/            # Extended documentation
└─ docker-compose.yml
```

For in‑depth documentation on each module, refer to the corresponding files inside `docs/`.

---

## 📄 Documentation

To avoid duplication and improve navigation, all extended guides have been moved to:

➡ **`docs/azure-deployment.md`** — Terraform, VM provisioning, cloud-init, monitoring stack, PromQL, and routes

➡ **`docs/architecture.md`** — System components, Docker services, metrics pipeline, diagrams

➡ **`docs/monitoring.md`** — Prometheus, Grafana dashboards, exporters, test traffic

➡ **`docs/cicd.md`** — GitHub Actions deployment pipeline

Each document focuses on a single topic and includes examples, screenshots, diagrams, and usage instructions.

---

## ▶ Running Locally

You can run the entire stack locally using Docker Compose:

```bash
docker compose up -d --build
```

Access the services:

* App: [http://localhost/](http://localhost/)
* Metrics: [http://localhost/metrics](http://localhost/metrics)
* Prometheus: [http://localhost:9090](http://localhost:9090)
* Grafana: [http://localhost:3000](http://localhost:3000)

---

## ☁ Azure Deployment

If you want to deploy CloudOps Orchestrator in Microsoft Azure using Terraform:

➡ Follow the full guide in **`docs/azure-deployment.md`**.

The guide explains:

* How to deploy the VM and networking
* How cloud-init (`user_data.sh`) installs and provisions the stack
* Prometheus/Grafana automatic setup
* Useful URLs & dashboards

---

## 🤖 CI/CD Deployment (Optional)

The repository includes a GitHub Actions workflow that can:

* Validate Terraform
* SSH into the Azure VM
* Pull and redeploy updated Docker services

Full documentation:
➡ `docs/cicd.md`

---

## 📜 License

This project is distributed under the **MIT License**. See the `LICENSE` file for details.

---

## ✨ Author

**Aldara Castro Mosquera**

Cloud & DevOps Enthusiast — Galicia, Spain

---

# 🇪🇸 Versión en Español

# CloudOps Orchestrator

CloudOps Orchestrator es una solución completa de despliegue y monitorización construida con **Flask**, **Docker Compose**, **PostgreSQL**, **Nginx**, **Prometheus** y **Grafana**. Incluye además automatización opcional de infraestructura mediante **Terraform** y **Azure**, así como un flujo CI/CD mediante **GitHub Actions**.

Este README ofrece una visión general del proyecto.
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

➡ [docs/monitoring.md](./docs/monitoring.md) — Prometheus, dashboards de Grafana, exporters, generación de tráfico

➡ [docs/cicd.md](./docs/cicd.md) — Pipeline de despliegue mediante GitHub Actions

---

## Ejecutar Localmente

Puedes ejecutar todo el stack usando Docker Compose:

```bash
docker compose up -d --build
```

Accede a los servicios:

* Aplicación: [http://localhost/](http://localhost/)
* Métricas: [http://localhost/metrics](http://localhost/metrics)
* Prometheus: [http://localhost:9090](http://localhost:9090)
* Grafana: [http://localhost:3000](http://localhost:3000)

---

## Despliegue en Azure

Si deseas desplegar CloudOps Orchestrator en Azure mediante Terraform:

➡ Sigue la guía completa en [docs/azure-deployment.md](./docs/README-AZURE.md)

La guía explica:

* Cómo se despliega la máquina virtual y la red
* Cómo *cloud-init* (`user_data.sh`) instala y configura el stack
* Configuración automática de Prometheus y Grafana
* Rutas útiles y dashboards preconfigurados

---

## CI/CD 

El repositorio incluye un flujo de GitHub Actions capaz de:

* Validar Terraform
* Conectarse por SSH a la VM en Azure
* Actualizar y desplegar nuevamente los servicios Docker

➡ Sigue la guía completa en [docs/cicd.md](./docs/cicd.md)

---

## Autor
**Aldara Castro Mosquera**  
*Cloud & DevOps Enthusiast*  
Galicia, España  

---

## ⚠️ Licencia
Consulta el archivo [LICENSE](./LICENSE) para más detalles.

══════════════════════════════════════════════════════════════════════════

🇬🇧 English

CloudOps Orchestrator is a fully automated deployment and monitoring solution built with **Flask**, **Docker Compose**, **PostgreSQL**, **Nginx**, **Prometheus**, and **Grafana**. It includes optional infrastructure automation using **Terraform** and **Azure**, as well as CI/CD integration with **GitHub Actions**.

This README provides a high‑level overview of the project. 

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

➡ [docs/monitoring.md](./docs/monitoring.md) — Prometheus, Grafana dashboards, exporters, test traffic

➡ [docs/cicd.md](./docs/cicd.md) — GitHub Actions deployment pipeline

Each document focuses on a single topic and includes examples, screenshots, diagrams, and usage instructions.

---

## Running Locally

You can run the entire stack locally using Docker Compose:

```bash
docker compose up -d --build
```

Access the services:

* App: [http://localhost/](http://localhost/)
* Metrics: [http://localhost/metrics](http://localhost/metrics)
* Prometheus: [http://localhost:9090](http://localhost:9090)
* Grafana: [http://localhost:3000](http://localhost:3000)

---

## Azure Deployment

If you want to deploy CloudOps Orchestrator in Microsoft Azure using Terraform:

➡ Follow the full guide in [docs/README-AZURE.md](./docs/README-AZURE.md)

The guide explains:

* How to deploy the VM and networking
* How cloud-init (`user_data.sh`) installs and provisions the stack
* Prometheus/Grafana automatic setup
* Useful URLs & dashboards

---

## CI/CD Deployment

The repository includes a GitHub Actions workflow that can:

* Validate Terraform
* SSH into the Azure VM
* Pull and redeploy updated Docker services

➡ Follow the full guide in **`docs/cicd.md`**(./docs/cicd.md)

---

## Author
**Aldara Castro Mosquera**  
*Cloud & DevOps Enthusiast*  
Galicia, Spain  

---

## ⚠️ License
See the [LICENSE](./LICENSE) file for more details.