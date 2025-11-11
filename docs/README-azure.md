# CLOUDOPS ORCHESTRATOR — Azure Deployment Guide

> **Automatización del despliegue en Microsoft Azure usando Terraform y Docker**

## 🇪🇸 Español

### Descripción general
Esta guía explica cómo desplegar **CloudOps Orchestrator en Azure** utilizando **Terraform**.  
El objetivo es automatizar la creación de los recursos necesarios para ejecutar la aplicación Dockerizada en una máquina virtual Linux.

Incluye:
- Configuración del proveedor **azurerm**  
- Creación de red virtual, subred y grupo de seguridad  
- Despliegue de una **VM Ubuntu** con **Docker preinstalado**  
- Ejecución automática de `docker compose up -d`

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
az login
```
#### 3. **Terraform instalado** (v1.5+ recomendado):
```
terraform -version
```

---

### Despliegue paso a paso
#### 1. Inicializar Terraform
```
cd terraform/azure
terraform init
```
#### 2. Revisar y ajustar variables
Edita variables.tf o crea un archivo terraform.tfvars personalizado:
```
resource_group_name = "cloudops-rg"
location            = "westeurope"
admin_username      = "azureuser"
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
**Espera unos minutos** mientras Azure crea la red, VM y ejecuta el script de instalación.

#### 5. Ver resultados
Al finalizar, Terraform mostrará:
```
Outputs:

public_ip = "52.174.xxx.xxx"
```

**Abre esa IP en tu navegador** → http://52.174.xxx.xxx

Deberías ver el mensaje:

>Hola desde CloudOps Orchestrator!

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
**Resultado**: el sistema se autoconfigura y lanza la app Flask con Nginx y Postgres en segundos.

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
### Overview
This guide explains how to deploy **CloudOps Orchestrator** on Azure using **Terraform**.
The goal is to automate the provisioning of the infrastructure needed to run the Dockerized app on a Linux virtual machine.

Includes:
- Configuration of the azurerm provider
- Creation of a virtual network, subnet, and network security group
- Deployment of an Ubuntu VM with Docker preinstalled
- Automatic execution of docker compose up -d

---

### Prerequisites
#### 1. Active **Azure account**
#### 2. **Azure CLI** installed and logged in:
```
az login
```
#### 3. **Terraform installed** (v1.5+ recommended):
```
terraform -version
```

---

### Deployment steps
```
cd terraform/azure
terraform init
terraform apply -auto-approve
```
After a few minutes, Terraform will show the **public IP of the VM**.
**Open it in your browser** to verify that the application is running.

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