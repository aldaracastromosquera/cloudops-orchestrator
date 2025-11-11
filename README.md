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
| 2️ | **Infraestructura Cloud** — Terraform (Azure / AWS / GCP) | En progreso |
| 3️ | **CI/CD** — Validación y despliegue automático | Completado |
| 4️ | **Monitoring** — Prometheus + Grafana | Próximamente |
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

### Licencia
Este proyecto se distribuye bajo la licencia **MIT**, lo que significa que puedes:  
- Usarlo libremente para fines **educativos o profesionales**.  
- **Modificarlo, compartirlo y adaptarlo**, siempre citando su origen.  

📄 Consulta el archivo [LICENSE](./LICENSE) para más detalles.

---