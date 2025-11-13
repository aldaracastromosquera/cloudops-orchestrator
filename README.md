# CLOUDOPS ORCHESTRATOR

## 🇪🇸 Español

### Descripción general
**CloudOps Orchestrator** es una herramienta modular que permite **desplegar aplicaciones Docker** de forma automática en distintos entornos (local, Azure, AWS y GCP).  
Integra **Terraform** para la infraestructura como código (IaC), **Docker Compose** para entornos locales y **GitHub Actions** para CI/CD.  
Incluye **Prometheus y Grafana** para monitorización básica y exposición de métricas, siguiendo las mejores prácticas DevOps.

---

### Estructura del proyecto
```
cloudops-orchestrator/
├─ app/ # Código fuente de la aplicación Flask
│ ├─ main.py # Endpoints + métricas Prometheus
│ ├─ Dockerfile # Imagen de la app
│ └─ requirements.txt # Dependencias Python
│
├─ nginx/ # Configuración del proxy inverso Nginx
│ └─ default.conf
│
├─ terraform/ # Infraestructura como Código (IaC)
│ ├─ azure/
│ ├─ aws/
│ └─ gcp/
│
├─ docs/ # Documentación por proveedor cloud
│ ├─ README-azure.md
│ ├─ README-aws.md
│ └─ README-gcp.md
│
├─ .github/workflows/ # Pipeline CI/CD (validación automática)
│ └─ deploy.yml
│
├─ docker-compose.yml # Stack local: app + db + nginx
├─ Makefile # Comandos rápidos para desarrollo
└─ README.md # Este documento
```

---

### Ejecución local

#### Requisitos previos
- Docker + Docker Compose  
- Python 3.10+ (solo si se quiere ejecutar sin contenedor)  
- Terraform (para despliegue en nube)

#### Pasos rápidos

##### 1. Clonar el repositorio
```
git clone https://github.com/aldaracastromosquera/cloudops-orchestrator.git
cd cloudops-orchestrator
```

##### 2. Levantar los servicios
```
make up
```

##### 3. Ver logs
```
make logs
```
La aplicación quedará accesible en http://localhost:8000

Endpoints disponibles:

- / → Mensaje principal
- /health → Estado del servicio
- /metrics → Métricas Prometheus

---
 
### Filosofía del proyecto
>“Automatiza todo lo que puedas, pero entiende lo que automatizas.”

Este proyecto busca combinar aprendizaje y práctica real de DevOps, abarcando:

- Infraestructura reproducible con Terraform
- Despliegue modular por proveedor cloud
- Contenedores portables con Docker
- Automatización CI/CD con GitHub Actions
- Monitorización y métricas con Prometheus + Grafana

---

### Roadmap

|  Fase |  Descripción |  Estado |
|:--------:|:---------------|:-----------|
| 1️ | **Core Local** — Docker Compose + Flask + Nginx + Postgres | Completado |
| 2️ | **Infraestructura Cloud** — Terraform (Azure) | Completado |
| 3️ | **CI/CD** — Validación y despliegue automático | Completado |
| 4️ | **Monitoring** — Prometheus + Grafana | Completado |
| 5️ | **Multi-Cloud** — Despliegue completo en todas las nubes | Próximamente |


---

### Tecnologías utilizadas

- Python 3.12
- Flask
- Prometheus Client
- Docker / Docker Compose
- Terraform
- Nginx
- GitHub Actions

---

### Autor
**Aldara Castro Mosquera**  
*Cloud & DevOps Enthusiast*  
Galicia, España  

---

### ⚠️ Licencia
Consulta el archivo [LICENSE](./LICENSE) para más detalles.



════════════════════════════════════════════════════



## 🇬🇧 English

### Overview
**CloudOps Orchestrator** is a modular tool that allows you to **automatically deploy Docker applications** across multiple environments (local, Azure, AWS, and GCP).  
It integrates **Terraform** for Infrastructure as Code (IaC), **Docker Compose** for local setups, and **GitHub Actions** for CI/CD.  
Includes **Prometheus and Grafana** for basic monitoring and metrics exposure, following DevOps best practices.

---

### Project structure
```
cloudops-orchestrator/
├─ app/ # Flask application source code
│ ├─ main.py # Endpoints + Prometheus metrics
│ ├─ Dockerfile # App image
│ └─ requirements.txt # Python dependencies
│
├─ nginx/ # Nginx reverse proxy configuration
│ └─ default.conf
│
├─ terraform/ # Infrastructure as Code (IaC)
│ ├─ azure/
│ ├─ aws/
│ └─ gcp/
│
├─ docs/ # Cloud provider documentation
│ ├─ README-azure.md
│ ├─ README-aws.md
│ └─ README-gcp.md
│
├─ .github/workflows/ # CI/CD pipeline (automatic validation)
│ └─ deploy.yml
│
├─ docker-compose.yml # Local stack: app + db + nginx
├─ Makefile # Quick development commands
└─ README.md # This document
```

---

### Local execution

#### Prerequisites
- Docker + Docker Compose  
- Python 3.10+ (only if running without containers)  
- Terraform (for cloud deployment)

#### Quick steps

##### 1. Clone the repository
```
git clone https://github.com/aldaracastromosquera/cloudops-orchestrator.git
cd cloudops-orchestrator
```

##### 2. Start the services
```
make up
```

##### 3. View logs
```
make logs
```

The application will be available at http://localhost:8000

Available endpoints:

- / → Main message  
- /health → Service status  
- /metrics → Prometheus metrics

---

### Project philosophy
> “Automate everything you can, but understand what you automate.”

This project aims to combine **learning and real-world DevOps practice**, covering:

- Reproducible infrastructure with Terraform  
- Modular deployment per cloud provider  
- Portable containers with Docker  
- CI/CD automation with GitHub Actions  
- Monitoring and metrics with Prometheus + Grafana

---

### Roadmap

|  Phase |  Description |  Status |
|:--------:|:---------------|:-----------|
| 1️ | **Local Core** — Docker Compose + Flask + Nginx + Postgres | Completed |
| 2️ | **Cloud Infrastructure** — Terraform (Azure) | Completed |
| 3️ | **CI/CD** — Validation and automatic deployment | Completed |
| 4️ | **Monitoring** — Prometheus + Grafana | Completed |
| 5️ | **Multi-Cloud** — Full deployment across all clouds | Coming soon |

---

### Technologies used

- Python 3.12  
- Flask  
- Prometheus Client  
- Docker / Docker Compose  
- Terraform  
- Nginx  
- GitHub Actions  

---

### Author
**Aldara Castro Mosquera**  
*Cloud & DevOps Enthusiast*  
Galicia, Spain  

---

### ⚠️ License
See the [LICENSE](./LICENSE) file for more details.