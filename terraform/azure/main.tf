#  Define los recursos que Terraform desplegará en Microsoft Azure: grupo de recursos, red, VM y seguridad.


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"     # Proveedor de Azure para Terraform
      version = "~>3.116.0"             # Versión 
    }
  }

  required_version = ">= 1.5.0"         # Versión de Terraform
}

# ---- Proveedor de Azure ----
provider "azurerm" {
  features {}                            # Habilita features por defecto
}

# ---- Grupo de recursos ----
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name     # Nombre (variables.tf)
  location = var.location                # Región (variables.tf)
}

# ---- Red virtual ----
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"                  # Nombre (variables.tf)
  address_space       = ["10.0.0.0/16"]                       # Rango IP para toda la VNet
  location            = var.location                          # Región (variables.tf)
  resource_group_name = azurerm_resource_group.rg.name        # Grupo de recursos creado
}

# ---- Subred ----
resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"               # Nombre (variables.tf)
  resource_group_name  = azurerm_resource_group.rg.name       # Grupo de recursos creado
  virtual_network_name = azurerm_virtual_network.vnet.name    # VNet creada
  address_prefixes     = ["10.0.1.0/24"]                      # Rango IP específico de la subred
}

# ---- IP pública ----
resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-pip"                   # Nombre (variables.tf)
  location            = var.location                          # Región (variables.tf)
  resource_group_name = azurerm_resource_group.rg.name        # Grupo de recursos creado  
  allocation_method   = "Static"                              # Standard requiere estática 
  sku                 = "Standard"                            # Cambiar de Basic a Standard (requisito Azure, dio error)              
}

# ---- Grupo de seguridad  ----
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"                   # Nombre (variables.tf)
  location            = var.location                          # Región (variables.tf)
  resource_group_name = azurerm_resource_group.rg.name        # Grupo de recursos creado

  # Permitir tráfico HTTP (puerto 80) desde Internet
  security_rule {
    name                       = "HTTP"                       # Nombre de la regla
    priority                   = 1001                         # Menor número = mayor prioridad
    direction                  = "Inbound"                    # Tráfico entrante hacia la VM
    access                     = "Allow"                      # Permitir
    protocol                   = "Tcp"                        # Protocolo TCP 
    source_port_range          = "*"                          # Cualquier puerto de origen
    destination_port_range     = "80"                         # Puerto destino 80 (Nginx)
    source_address_prefix      = "*"                          # Desde cualquier IP
    destination_address_prefix = "*"                          # Hacia la VM
  }

  # Permitir acceso SSH (puerto 22) para administración
  security_rule {
    name                       = "SSH"                        # Nombre de la regla
    priority                   = 1002                         # Menor número = mayor prioridad
    direction                  = "Inbound"                    # Tráfico entrante hacia la VM
    access                     = "Allow"                      # Permitir
    protocol                   = "Tcp"                        # Protocolo TCP
    source_port_range          = "*"                          # Cualquier puerto de origen
    destination_port_range     = "22"                         # Puerto destino 22 (SSH)
    source_address_prefix      = "*"                          # (Debería restringir a IP pública)
    destination_address_prefix = "*"                          # Hacia la VM
  }
}

# ---- Interfaz de red ----
resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-nic"                   # Nombre (variables.tf)
  location            = var.location                          # Región (variables.tf)
  resource_group_name = azurerm_resource_group.rg.name        # Grupo de recursos creado

  ip_configuration {
    name                          = "internal"                    # Nombre de la configuración IP
    subnet_id                     = azurerm_subnet.subnet.id      # Subred creada
    private_ip_address_allocation = "Dynamic"                     # IP privada dinámica
    public_ip_address_id          = azurerm_public_ip.pip.id      # Asocia la IP pública creada
  }
}

# ---- Asociación entre la interfaz de red (NIC) y el grupo de seguridad (NSG) ----
# Así, las reglas de seguridad definidas se aplican realmente al tráfico de esa VM.
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# ---- Máquina virtual Linux ----
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${var.prefix}-vm"                  # Nombre (variables.tf)
  resource_group_name   = azurerm_resource_group.rg.name      # Grupo de recursos creado
  location              = var.location                        # Región (variables.tf) 
  size                  = var.vm_size                         # Tamaño de la VM (variables.tf)
  admin_username        = var.admin_username                  # Administrador (variables.tf)
  admin_password        = var.admin_password                  # Contraseña (variables.tf)
  disable_password_authentication = false                     # Permite login por password (true para solo SSH)
  network_interface_ids = [azurerm_network_interface.nic.id]  # NIC asociada a la VM

  os_disk {
    caching              = "ReadWrite"                        # Caché de disco
    storage_account_type = "Standard_LRS"                     # Disco estándar (barato)
  }

  # Imagen base: Ubuntu 20.04 LTS (Focal)
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  # Script cloud-init (Base64) que instala Docker y levanta la app
  custom_data = filebase64("${path.module}/user_data.sh")
}