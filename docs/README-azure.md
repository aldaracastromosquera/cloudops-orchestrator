# CLOUDOPS ORCHESTRATOR — Azure Deployment Guide

> **Automatización del despliegue en Microsoft Azure usando Terraform y Docker**

## 🇪🇸 Español

### Descripción general
Este documento explica cómo desplegar **CloudOps Orchestrator en Azure** usando:

- **Terraform** → Infraestructura reproducible  
- **user_data.sh (cloud-init)** → Automatiza instalación y despliegue  
- **Docker Compose** → Levanta la app Flask + Nginx + Postgres  
- **Prometheus & Grafana** → Monitorización automática  
- **Node Exporter & cAdvisor** → Métricas de host y contenedores  
- **GitHub Actions** → CI/CD opcional para actualización remota  

---

## Resultado final

La máquina virtual creada por Terraform se vuelve **autosuficiente** y, al arrancar:

- Instala Docker y todas las dependencias necesarias  
- Crea un usuario SSH dedicado para administración y CI/CD  
- Clona este repositorio en `/opt/cloudops`  
- Ejecuta `docker compose up -d --build` para montar toda la arquitectura  
- Provisiona automáticamente **Prometheus** y **Grafana**  
- Expone la aplicación Flask a través de **Nginx** en el puerto **80**

El entorno queda totalmente automatizado, reproducible y listo para producción.


---

### Estructura de archivos Terraform

```
terraform/
└─ azure/
├─ main.tf # Definición principal (recursos de Azure)
├─ variables.tf # Variables reutilizables
├─ outputs.tf # Salidas con IP pública y datos útiles
└─ user_data.sh # Script de inicialización (instala Docker y lanza la app)
```

---

### Requisitos previos

#### 1. **Cuenta de Azure** activa  
#### 2. **Azure CLI** instalada y autenticada:
```
winget install -e --id Microsoft.AzureCLI
az version
```
#### 3. **Terraform instalado** (v1.5+ recomendado):
```
winget install -e --id HashiCorp.Terraform
terraform -version
```
#### 4. **Git instalado** (para clonar repositorio):
```
winget install -e --id Git.Git
git --version
```

---

### Despliegue paso a paso
#### 1. Clonar el repositorio
```
cd $HOME\Desktop
git clone https://github.com/aldaracastromosquera/cloudops-orchestrator.git
cd .\cloudops-orchestrator\terraform\azure
```
#### 2. Iniciar sesión en Azure:
```
cd $HOME\Desktop
git clone https://github.com/aldaracastromosquera/cloudops-orchestrator.git
cd .\cloudops-orchestrator\terraform\azure
```
Selecciona tu suscripción si tienes varias:
```
az login
az account list --output table
az account set --subscription "<NOMBRE O ID>"
```
#### 3. Inicializar Terraform
```
terraform init
```
#### 2. Revisar y ajustar variables
Edita variables.tf o crea un archivo terraform.tfvars personalizado:
```
resource_group_name = "cloudops-rg"
location            = "westeurope"
vm_size             = "Standard_B1s"
```
#### 3. Previsualizar cambios
```
terraform plan
```
#### 4. Aplicar el despliegue
```
terraform apply -auto-approve
```
Espera unos minutos mientras Azure crea la red, VM y ejecuta el script de instalación.

#### 5. Ver resultados
Al finalizar, Terraform mostrará:
```
Outputs:

public_ip = "xxx.xxx.xxx.xxx"
```

Espera unos minutos y abre esa IP en tu navegador → http://xxx.xxx.xxx.xxx

Deberías ver el mensaje:

>Hola desde CloudOps Orchestrator!

---

## Servicios desplegados automáticamente

| Servicio       | Puerto              | Descripción                                      |
|----------------|---------------------|--------------------------------------------------|
| **Nginx**      | **80**              | Reverse proxy hacia Flask                        |
| **Flask API**  | **8000** (interno)  | Backend de CloudOps                              |
| **PostgreSQL** | **5432** (interno)  | Base de datos                                    |
| **Prometheus** | **9090**            | Métricas de aplicación + nodo + contenedores     |
| **Grafana**    | **3000**            | Dashboards preconfigurados                       |
| **cAdvisor**   | **8081**            | Métricas detalladas de contenedores              |
| **Node Exporter** | **9100**         | Métricas del host (CPU, RAM, disco…)             |

---

## 🌐 Rutas útiles del despliegue

Una vez creada la VM y obtenida la IP pública (`http://xxx.xxx.xxx.xxx`), puedes acceder a:

| Servicio / Ruta | URL (ejemplo) | Descripción |
|------------------|---------------------------|-------------|
| **Página principal** | `http://<IP_PUBLICA>/` | Respuesta principal de CloudOps Orchestrator |
| **Health check** | `http://<IP_PUBLICA>/health` | Verifica que la API está viva |
| **Métricas de la app Flask** | `http://<IP_PUBLICA>/metrics` | Exportación Prometheus desde Flask |
| **Prometheus UI** | `http://<IP_PUBLICA>:9090` | Consultas PromQL y estado del scraping |
| **Prometheus → Targets** | `http://<IP_PUBLICA>:9090/targets` | Muestra si Prometheus detecta la app, node_exporter y cAdvisor |
| **Prometheus → Graph** | `http://<IP_PUBLICA>:9090/graph` | Ejecutar queries como `app_requests_total` o `rate(...)` |
| **Grafana Dashboard** | `http://<IP_PUBLICA>:3000` | Dashboards preconfigurados (user: admin / pass: admin)* |
| **cAdvisor** | `http://<IP_PUBLICA>:8081` | Métricas de contenedores Docker |
| **Node Exporter** | `http://<IP_PUBLICA>:9100/metrics` | Métricas del host (CPU, RAM, disco…) |

### * Puedes generar tráfico de prueba para comprobar que Prometheus recoge las métricas correctamente y que Grafana muestra datos en los dashboards, puedes generar tráfico simulado hacia la API.
#### Ejecuta desde Powershell 
```
# 300 peticiones a /
1..300 | % { iwr http://<IP_PUBLICA>/ | Out-Null }

# 100 peticiones a /health
1..100 | % { iwr http://<IP_PUBLICA>/health | Out-Null }
```

---

### 🎯 Consultas PromQL recomendadas

| Métrica | Query | Explicación |
|---------|--------|-------------|
| Total por endpoint | `app_requests_total` | Contador absoluto de peticiones |
| Peticiones solo `/` | `app_requests_total{endpoint="/"}` | Total acumulado de la ruta principal |
| Peticiones/seg | `rate(app_requests_total[5m])` | Promedio de 5 minutos por endpoint |
| CPU proceso Flask | `rate(process_cpu_seconds_total[5m])` | Uso de CPU del backend |
| RAM proceso Flask (MB) | `process_resident_memory_bytes / 1024 / 1024` | Conversión de bytes a MB |

---

Si quieres también te preparo una **tabla con las credenciales por defecto**, otra con **los contenedores Docker** o una sección de **troubleshooting** para Azure.

---

### Limpieza del entorno
Cuando termines las pruebas, destruye todos los recursos:
```
terraform destroy -auto-approve
```
Así evitarás costos innecesarios en tu cuenta de Azure.

---

### Conceptos clave
| Recurso | Descripción |
|:-----------------------------|:-----------------------------------------------|
| `azurerm_resource_group` | Agrupa todos los recursos desplegados |
| `azurerm_virtual_network` | Red privada donde se aloja la máquina virtual |
| `azurerm_subnet` | Subred interna asociada a la red virtual |
| `azurerm_network_interface` | Conecta la VM a la red |
| `azurerm_public_ip` | IP pública para acceder a la aplicación |
| `azurerm_linux_virtual_machine` | Instancia principal que ejecuta Docker |

---

### Filosofía del despliegue
>“Infraestructura reproducible, sin clics y sin miedo.”

Este módulo Azure demuestra cómo pasar de una app local a un entorno cloud completamente automatizado.
Cada despliegue es idéntico, seguro y versionable, gracias a Terraform.

---

### Outputs típicos
Tras un despliegue exitoso, verás:
```
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

public_ip = "52.174.100.42"
vm_name   = "cloudops-vm"
```
Y podrás acceder directamente desde tu navegador o hacer ping con:
```
curl http://$(terraform output -raw public_ip)
```

---

### Detalle del user_data.sh
Este script se ejecuta automáticamente al iniciar la VM y prepara todo el entorno:
```
#!/bin/bash
apt update -y
apt install -y docker.io docker-compose-plugin git
git clone https://github.com/aldaracastromosquera/cloudops-orchestrator.git /opt/cloudops
cd /opt/cloudops
docker compose up -d
```
Resultado: el sistema se autoconfigura y lanza la app Flask con Nginx y Postgres en segundos.

---

### Integración con GitHub Actions (opcional)
Puedes ampliar el flujo CI/CD para que GitHub valide la infraestructura:
```
- name: Terraform validate (Azure)
  working-directory: terraform/azure
  run: |
    terraform init -backend=false
    terraform validate
```
Esto asegura que cada commit mantenga la infraestructura lista para desplegar.

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

Consulta el archivo [LICENSE](./LICENSE) para más detalles.



════════════════════════════════════════════════════

🇬🇧 English
## Overview  
This guide explains how to deploy **CloudOps Orchestrator on Azure** using the following technologies:

- **Terraform** → Reproducible infrastructure  
- **user_data.sh (cloud-init)** → Automates installation and deployment  
- **Docker Compose** → Runs the Flask app + Nginx + PostgreSQL  
- **Prometheus & Grafana** → Automatic monitoring  
- **Node Exporter & cAdvisor** → Host and container metrics  
- **GitHub Actions** → Optional CI/CD for remote updates  

---

## Final Result

The virtual machine created by Terraform becomes **fully self-managing**, and on first boot it:

- Installs Docker and all required dependencies  
- Creates a dedicated SSH user for administration and CI/CD  
- Clones this repository into `/opt/cloudops`  
- Executes `docker compose up -d --build` to start the full architecture  
- Automatically provisions **Prometheus** and **Grafana**  
- Exposes the Flask API through **Nginx** on port **80**

The environment is fully automated, reproducible, and production-ready.

---

## Prerequisites
### 1. Active **Azure account**
### 2. **Azure CLI** installed and logged in:
```
winget install -e --id Microsoft.AzureCLI
az version
```
### 3. **Terraform installed** (v1.5+ recommended):
```
winget install -e --id HashiCorp.Terraform
terraform -version
```
### 4. **Git installed**:
```
winget install -e --id Git.Git
git version
```

---

### Deployment steps
```
cd $HOME\Desktop
git clone https://github.com/aldaracastromosquera/cloudops-orchestrator.git
cd .\cloudops-orchestrator\terraform\azure
az login
terraform init
terraform apply -auto-approve

```
After a few minutes, Terraform will show the public IP of the VM.
```
public_ip = "52.174.xxx.xxx"
```
Open it in your browser to verify that the application is running.

---

### Cleanup
Destroy the resources when done:
```
terraform destroy -auto-approve
```

---

### Philosophy
>“Reproducible infrastructure, without clicks and without fear.”

This Azure module shows how to go from a local app to a fully automated cloud environment.
Every deployment is consistent, safe, and version-controlled, thanks to Terraform.

---

### Author
**Aldara Castro Mosquera**  
*Cloud & DevOps Enthusiast*  
Galicia, Spain  

---

### License
This project is distributed under the **MIT license**, which means you can:  
- Use it freely for **educational or professional purposes**.  
- **Modify, share, and adapt** it, always giving credit to the original source.  

See the [LICENSE](./LICENSE) file for more details.