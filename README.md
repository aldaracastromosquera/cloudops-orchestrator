# 🌩️ CloudOps Orchestrator

> **Automatización DevOps Multicloud — Terraform + Docker + CI/CD**

---

## 🇪🇸 Español

### 💡 Descripción general
**CloudOps Orchestrator** es una herramienta modular que permite **desplegar aplicaciones Dockerizadas** de forma automática en distintos entornos (local, Azure, AWS y GCP).  
Integra **Terraform** para la infraestructura como código (IaC), **Docker Compose** para entornos locales y **GitHub Actions** para CI/CD.  
Incluye **Prometheus y Grafana** para monitorización básica y exposición de métricas, siguiendo las mejores prácticas DevOps.

---

### 🧱 Estructura del proyecto

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


### 🚀 Ejecución local

#### 🧩 Requisitos previos
- Docker + Docker Compose  
- Python 3.10+ (solo si se quiere ejecutar sin contenedor)  
- Terraform (para despliegue en nube)

#### ▶️ Pasos rápidos

# 1. Clonar el repositorio
git clone https://github.com/aldaracastromosquera/cloudops-orchestrator.git
cd cloudops-orchestrator

# 2. Levantar los servicios
make up

# 3. Ver logs
make logs
La aplicación quedará accesible en
👉 http://localhost:8000

Endpoints disponibles:

/ → Mensaje principal

/health → Estado del servicio

/metrics → Métricas Prometheus

🧠 Filosofía del proyecto
“Automatiza todo lo que puedas, pero entiende lo que automatizas.”

Este proyecto busca combinar aprendizaje y práctica real de DevOps, abarcando:

🌍 Infraestructura reproducible con Terraform

🧩 Despliegue modular por proveedor cloud

🐳 Contenedores portables con Docker

⚙️ Automatización CI/CD con GitHub Actions

📊 Monitorización y métricas con Prometheus + Grafana

📊 Roadmap
Fase	Descripción	Estado
1️⃣ Core Local	Docker Compose + Flask + Nginx + Postgres	✅ Completado
2️⃣ Infraestructura Cloud	Terraform (Azure / AWS / GCP)	🏗️ En progreso
3️⃣ CI/CD	Validación y despliegue automático	✅
4️⃣ Monitoring	Prometheus + Grafana	🔄 Próximamente
5️⃣ Multi-Cloud	Despliegue completo en todas las nubes	🔜 Planificado

🧩 Tecnologías utilizadas
Python 3.12

Flask

Prometheus Client

Docker / Docker Compose

Terraform

Nginx

GitHub Actions

👩‍💻 Autor
Aldara Castro Mosquera
Cloud & DevOps Enthusiast ☁️
🔗 GitHub Profile

🧾 Licencia
Proyecto bajo licencia MIT.
Puedes usarlo libremente para fines educativos o profesionales, citando su origen.

“CloudOps Orchestrator: donde la infraestructura se convierte en arte automatizado.” ✨

🇬🇧 English
💡 Overview
CloudOps Orchestrator is a modular tool that allows you to automate Dockerized application deployments across multiple environments (local, Azure, AWS, and GCP).
It integrates Terraform for Infrastructure as Code (IaC), Docker Compose for local testing, and GitHub Actions for CI/CD automation.
Includes Prometheus and Grafana for monitoring and metrics exposure, following modern DevOps best practices.

🧱 Project structure
(Same as above, translated)

🚀 Run locally
🧩 Requirements
Docker + Docker Compose

Python 3.10+ (optional for manual run)

Terraform (for cloud deployment)

▶️ Quick start
bash
Copy code
git clone https://github.com/aldaracastromosquera/cloudops-orchestrator.git
cd cloudops-orchestrator
make up
make logs
App available at http://localhost:8000

Endpoints:

/ → Main route

/health → Service health

/metrics → Prometheus metrics

🧠 Project philosophy
“Automate everything you can, but understand what you automate.”

Combines learning and real-world DevOps practice, including:

🌍 Reproducible infrastructure with Terraform

🧩 Modular cloud deployments

🐳 Portable containers with Docker

⚙️ CI/CD automation via GitHub Actions

📊 Observability with Prometheus + Grafana

📊 Roadmap
(same as Spanish, translated)

👩‍💻 Author
Aldara Castro Mosquera
Cloud & DevOps Enthusiast ☁️
🔗 GitHub Profile

🧾 License
Licensed under MIT — free to use for educational or professional purposes, with attribution.

“CloudOps Orchestrator: where infrastructure becomes automated art.” ✨

