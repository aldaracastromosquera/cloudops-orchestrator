# CLOUDOPS ORCHESTRATOR — Azure Deployment Guide

> **Automatización del despliegue en Microsoft Azure usando Terraform y Docker**

## 🇪🇸 Español

## Descripción general
Este documento explica cómo desplegar **CloudOps Orchestrator en Azure** usando:

- **Terraform** → Infraestructura reproducible  
- **user_data.sh (cloud-init)** → Automatiza instalación y despliegue  
- **Docker Compose** → Levanta la app Flask + Nginx + Postgres  
- **Prometheus & Grafana** → Monitorización automática  
- **Node Exporter & cAdvisor** → Métricas de host y contenedores  
- **GitHub Actions** → CI/CD opcional para actualización remota  

### Resultado final

La máquina virtual creada por Terraform se vuelve **autosuficiente** y, al arrancar:

- Instala Docker y todas las dependencias necesarias  
- Crea un usuario SSH dedicado para administración y CI/CD  
- Clona este repositorio en `/opt/cloudops`  
- Ejecuta `docker compose up -d --build` para montar toda la arquitectura  
- Provisiona automáticamente **Prometheus** y **Grafana**  
- Expone la aplicación Flask a través de **Nginx** en el puerto **80**

El entorno queda totalmente automatizado, reproducible y listo para producción.


---

## Estructura de archivos Terraform

```
terraform/
└─ azure/
├─ main.tf # Definición principal (recursos de Azure)
├─ variables.tf # Variables reutilizables
├─ outputs.tf # Salidas con IP pública y datos útiles
└─ user_data.sh # Script de inicialización (instala Docker y lanza la app)
```

---

## Requisitos previos

- **Cuenta de Azure** activa  
- **Azure CLI** instalada y autenticada:
```
winget install -e --id Microsoft.AzureCLI
az version
```
- **Terraform instalado** (v1.5+ recomendado):
```
winget install -e --id HashiCorp.Terraform
terraform -version
```
- **Git instalado** (para clonar repositorio):
```
winget install -e --id Git.Git
git --version
```

---

## Despliegue paso a paso
### 1. Clonar el repositorio
```
cd $HOME\Desktop
git clone https://github.com/aldaracastromosquera/cloudops-orchestrator.git
cd .\cloudops-orchestrator\terraform\azure
```
### 2. Iniciar sesión en Azure:
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
### 3. Inicializar Terraform
```
terraform init
```
### 4. Revisar y ajustar variables
Edita variables.tf o crea un archivo terraform.tfvars personalizado:
```
resource_group_name = "cloudops-rg"
location            = "westeurope"
vm_size             = "Standard_B1s"
```
### 5. Previsualizar cambios
```
terraform plan
```
### 6. Aplicar el despliegue
```
terraform apply -auto-approve
```
Espera unos minutos mientras Azure crea la red, VM y ejecuta el script de instalación.

### 7. Ver resultados
Al finalizar, Terraform mostrará:
```
Outputs:

public_ip = "xxx.xxx.xxx.xxx"
```

Espera unos minutos y abre esa IP en tu navegador → http://xxx.xxx.xxx.xxx

Deberías ver el mensaje:

>Hola desde CloudOps Orchestrator!

#### 7.1. Servicios desplegados automáticamente

| Servicio       | Puerto              | Descripción                                      |
|----------------|---------------------|--------------------------------------------------|
| **Nginx**      | **80**              | Reverse proxy hacia Flask                        |
| **Flask API**  | **8000** (interno)  | Backend de CloudOps                              |
| **PostgreSQL** | **5432** (interno)  | Base de datos                                    |
| **Prometheus** | **9090**            | Métricas de aplicación + nodo + contenedores     |
| **Grafana**    | **3000**            | Dashboards preconfigurados                       |
| **cAdvisor**   | **8081**            | Métricas detalladas de contenedores              |
| **Node Exporter** | **9100**         | Métricas del host (CPU, RAM, disco…)             |


#### 7.2. Rutas útiles del despliegue

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

##### 7.2.1. Puedes generar tráfico de prueba 
Para comprobar que Prometheus recoge las métricas correctamente y que Grafana muestra datos en los dashboards, puedes generar tráfico simulado hacia la API. Ejecuta desde Powershell: 
```
# 300 peticiones a /
1..300 | % { iwr http://<IP_PUBLICA>/ | Out-Null }

# 100 peticiones a /health
1..100 | % { iwr http://<IP_PUBLICA>/health | Out-Null }
```

##### 7.3. Consultas PromQL recomendadas

| Métrica | Query | Explicación |
|---------|--------|-------------|
| Total por endpoint | `app_requests_total` | Contador absoluto de peticiones |
| Peticiones solo `/` | `app_requests_total{endpoint="/"}` | Total acumulado de la ruta principal |
| Peticiones/seg | `rate(app_requests_total[5m])` | Promedio de 5 minutos por endpoint |
| CPU proceso Flask | `rate(process_cpu_seconds_total[5m])` | Uso de CPU del backend |
| RAM proceso Flask (MB) | `process_resident_memory_bytes / 1024 / 1024` | Conversión de bytes a MB |



### 8. Limpieza del entorno
Cuando termines las pruebas, destruye todos los recursos:
```
terraform destroy -auto-approve
```
Así evitarás costos innecesarios en tu cuenta de Azure.

---

## Conceptos clave
| Recurso | Descripción |
|:-----------------------------|:-----------------------------------------------|
| `azurerm_resource_group` | Agrupa todos los recursos desplegados |
| `azurerm_virtual_network` | Red privada donde se aloja la máquina virtual |
| `azurerm_subnet` | Subred interna asociada a la red virtual |
| `azurerm_network_interface` | Conecta la VM a la red |
| `azurerm_public_ip` | IP pública para acceder a la aplicación |
| `azurerm_linux_virtual_machine` | Instancia principal que ejecuta Docker |

---

## Filosofía del despliegue
>“Infraestructura reproducible, sin clics y sin miedo.”

Este módulo Azure demuestra cómo pasar de una app local a un entorno cloud completamente automatizado.
Cada despliegue es idéntico, seguro y versionable, gracias a Terraform.

---

## Autor
**Aldara Castro Mosquera**  
*Cloud & DevOps Enthusiast*  
Galicia, España  

---

## ⚠️ Licencia
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

### Final Result

The virtual machine created by Terraform becomes **fully self-managing**, and on first boot it:

- Installs Docker and all required dependencies  
- Creates a dedicated SSH user for administration and CI/CD  
- Clones this repository into `/opt/cloudops`  
- Executes `docker compose up -d --build` to start the full architecture  
- Automatically provisions **Prometheus** and **Grafana**  
- Exposes the Flask API through **Nginx** on port **80**

The environment is fully automated, reproducible, and production-ready.

---

## Terraform Project Structure
```
terraform/
└─ azure/
├─ main.tf # Main Azure resources
├─ variables.tf # Reusable variables
├─ outputs.tf # Useful outputs (public IP, VM name…)
└─ user_data.sh # Initialization script (Docker + app deployment)
```

---

##  Prerequisites

- Active Azure account

- Azure CLI installed and logged in
```
winget install -e --id Microsoft.AzureCLI
az version
```
- Terraform installed (v1.5+ recommended)
```
winget install -e --id HashiCorp.Terraform
terraform -version
```
- Git installed
```
winget install -e --id Git.Git
git version
```

---

## Deployment steps
### 1. Clone the repository
```
cd $HOME\Desktop
git clone https://github.com/aldaracastromosquera/cloudops-orchestrator.git
cd .\cloudops-orchestrator\terraform\azure
```
### 2. Choose your Azure Subscription
```
az login
az account list --output table
az account set --subscription "<NAME_OR_ID>"
```
### 3. Initialize Terraform
```
terraform init
```
### 4. Adjust variables
```
resource_group_name = "cloudops-rg"
location            = "westeurope"
vm_size             = "Standard_B2s"
```
### 5. Preview changes
```
terraform plan
```
### 6. Deploy infraestructure
```
terraform apply -auto-approve
```
After a few minutes, Terraform will show the public IP of the VM.
### 7. Results
```
Outputs:

public_ip = "xxx.xxx.xxx.xxx"
```
After a few minutes. open in your browser to verify that the application is running → http://xxx.xxx.xxx.xxx

You should see:

>Hola desde CloudOps Orchestrator!

#### 7.1. Services Deployed Automatically

| Service         | Port               | Description                                      |
|-----------------|--------------------|--------------------------------------------------|
| **Nginx**       | **80**             | Reverse proxy to Flask                           |
| **Flask API**   | **8000** (internal)| CloudOps backend                                 |
| **PostgreSQL**  | **5432** (internal)| Database                                         |
| **Prometheus**  | **9090**           | App, node, and container metrics                 |
| **Grafana**     | **3000**           | Preconfigured dashboards                         |
| **cAdvisor**    | **8081**           | Container metrics                                |
| **Node Exporter** | **9100**         | Host metrics (CPU, RAM, disk…)                   |

---

#### 7.2. Useful URLs After Deployment

Once the VM is ready, you can access the following endpoints:

| Feature / Route          | URL example                  | Description |
|--------------------------|------------------------------|-------------|
| **Main page**            | `http://<PUBLIC_IP>/`        | CloudOps Orchestrator response |
| **Health check**         | `http://<PUBLIC_IP>/health`  | API status |
| **App metrics (Flask)**  | `http://<PUBLIC_IP>/metrics` | Prometheus exporter |
| **Prometheus UI**        | `http://<PUBLIC_IP>:9090`    | PromQL queries |
| **Prometheus Targets**   | `http://<PUBLIC_IP>:9090/targets` | Scraped services |
| **Prometheus Graph**     | `http://<PUBLIC_IP>:9090/graph`   | Execute queries |
| **Grafana Dashboard**    | `http://<PUBLIC_IP>:3000`    | Dashboards (user: `admin` / pass: `admin`)* |
| **cAdvisor**             | `http://<PUBLIC_IP>:8081`    | Container metrics |
| **Node Exporter**        | `http://<PUBLIC_IP>:9100/metrics` | Host metrics |

##### 7.2.1. Generating Test Traffic 
To visualize metrics in Prometheus and Grafana, generate simulated traffic. From Powershell:
```
# 300 requests to /
1..300 | % { iwr http://<PUBLIC_IP>/ | Out-Null }

# 100 requests to /health
1..100 | % { iwr http://<PUBLIC_IP>/health | Out-Null }
```

#### 7.3. Recommended PromQL Queries

| Metric               | Query                                   | Explanation                    |
|----------------------|-------------------------------------------|--------------------------------|
| Total by endpoint    | `app_requests_total`                     | Absolute request count         |
| Only `/`             | `app_requests_total{endpoint="/"}`       | Total hits to the root path    |
| Requests per second  | `rate(app_requests_total[5m])`           | 5-minute moving average        |
| Flask CPU usage      | `rate(process_cpu_seconds_total[5m])`    | Backend CPU usage              |
| Flask RAM (MB)       | `process_resident_memory_bytes / 1024 / 1024` | Convert bytes to MB      |

### 8. Cleanup
Destroy the resources when done:
```
terraform destroy -auto-approve
```

---

## Key Concepts

| Resource                      | Description                               |
|-------------------------------|-------------------------------------------|
| `azurerm_resource_group`      | Groups all Azure resources                |
| `azurerm_virtual_network`     | Private virtual network                   |
| `azurerm_subnet`              | Subnet inside the VNet                    |
| `azurerm_network_interface`   | Network interface for the VM              |
| `azurerm_public_ip`           | Public IP assigned to the VM              |
| `azurerm_linux_virtual_machine` | VM running Docker and the application   |

---

## Philosophy
>“Reproducible infrastructure, without clicks and without fear.”

This Azure module shows how to go from a local app to a fully automated cloud environment.
Every deployment is consistent, safe, and version-controlled, thanks to Terraform.

---

## Author
**Aldara Castro Mosquera**  
*Cloud & DevOps Enthusiast*  
Galicia, Spain  

---

## ⚠️ License
See the [LICENSE](./LICENSE) file for more details.