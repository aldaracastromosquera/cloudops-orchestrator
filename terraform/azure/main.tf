# ============================
# Archivo: main.tf
# Propósito: definir todos los recursos que Terraform desplegará en Azure,
# incluyendo red, seguridad, IP pública y máquina virtual con Docker preinstalado.
# ============================

# --- Configuración principal de Terraform ---
terraform {
  # Define el proveedor requerido (Azure Resource Manager)
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"   # Fuente oficial del proveedor de Azure
      version = "~>3.116.0"           # Usa versiones compatibles >=3.116.0 y <4.0
    }
  }

  # Versión mínima requerida de Terraform para ejecutar este proyecto
  required_version = ">= 1.5.0"
}

# --- Proveedor de Azure ---
provider "azurerm" {
  # El bloque 'features' es obligatorio, aunque esté vacío.
  # Permite habilitar funcionalidades avanzadas del proveedor.
  features {}
}

# --- Grupo de recursos ---
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name   # Nombre definido en variables.tf
  location = var.location              # Región de Azure (por ejemplo, westeurope)
}

# --- Red virtual (VNet) ---
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"           # Ejemplo: cloudops-vnet
  address_space       = ["10.0.0.0/16"]                # Espacio de direcciones IP de la red
  location            = var.location                   # Misma región que el grupo de recursos
  resource_group_name = azurerm_resource_group.rg.name # Asociación al grupo de recursos
}

# --- Subred dentro de la VNet ---
resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"        # Ejemplo: cloudops-subnet
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]               # Rango IP reservado para la subred
}

# --- Dirección IP pública ---
resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-pip"            # Ejemplo: cloudops-pip
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"                       # IP fija (no dinámica)
  sku                 = "Standard"                     # SKU recomendado para producción
}

# --- Grupo de seguridad de red (NSG) ---
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"            # Ejemplo: cloudops-nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  # Regla para permitir tráfico HTTP (puerto 80)
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }

  # Regla para permitir acceso SSH (puerto 22)
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
}

# --- Interfaz de red (NIC) ---
resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-nic"            # Ejemplo: cloudops-nic
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  # Configuración de la IP
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"          # IP privada asignada automáticamente
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# --- Asociación de la NIC con el NSG ---
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# --- Máquina virtual Linux ---
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "${var.prefix}-vm"     # Ejemplo: cloudops-vm
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  size                            = var.vm_size            # Tamaño definido en variables.tf
  admin_username                  = var.admin_username     # Usuario administrador
  admin_password                  = var.admin_password     # Contraseña (para pruebas)
  disable_password_authentication = false                  # Permite login por contraseña
  network_interface_ids           = [azurerm_network_interface.nic.id]  # Asocia la NIC creada

  # --- Configuración del disco del sistema ---
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"   # Disco económico con redundancia local
  }

  # --- Imagen base del sistema operativo ---
  source_image_reference {
    publisher = "Canonical"                  # Proveedor de la imagen (Ubuntu)
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"                 # Ubuntu 20.04 LTS
    version   = "latest"                    # Usa la versión más reciente disponible
  }

  # --- Script de inicialización ---
  # Ejecuta el script user_data.sh al crear la máquina virtual.
  # Este script instalará Docker, Nginx y desplegará el proyecto automáticamente.
  custom_data = filebase64("${path.module}/user_data.sh")

  # --- Etiquetas para organización y gestión ---
  tags = {
    project = "cloudops-orchestrator"
    env     = "demo"
  }
}
