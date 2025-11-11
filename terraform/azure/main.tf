############################################################
#  Terraform: Azure RG + Networking + VM + NSG + cloud-init
############################################################

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116.0"
    }
  }
}

provider "azurerm" {
  features {}
}

########################
#  Resource Group
########################
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name   # ej: cloudops-rg
  location = var.location              # ej: westeurope
  tags = {
    project = "cloudops-orchestrator"
    env     = "demo"
  }
}

########################
#  Networking
########################
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name          # ej: cloudops-vnet
  address_space       = [var.vnet_cidr]        # ej: 10.0.0.0/16
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    project = "cloudops-orchestrator"
    env     = "demo"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name       # ej: default
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidr]     # ej: 10.0.1.0/24
}

# IP pública (SKU Standard recomendado)
resource "azurerm_public_ip" "pip" {
  name                = "${var.vm_name}-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    project = "cloudops-orchestrator"
    env     = "demo"
  }
}

# Interfaz de red
resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }

  tags = {
    project = "cloudops-orchestrator"
    env     = "demo"
  }
}

########################
#  NSG + reglas + asociación
########################
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vm_name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    project = "cloudops-orchestrator"
    env     = "demo"
  }
}

# SSH
resource "azurerm_network_security_rule" "ssh" {
  name                        = "SSH"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# HTTP
resource "azurerm_network_security_rule" "http" {
  name                        = "HTTP"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# HTTPS (opcional)
resource "azurerm_network_security_rule" "https" {
  name                        = "HTTPS"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Puerto directo de la app (opcional)
resource "azurerm_network_security_rule" "app8000" {
  name                        = "APP8000"
  priority                    = 1003
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8000"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Asociación NSG ↔ NIC  (usa esta o la de Subnet, pero no ambas)
resource "azurerm_network_interface_security_group_association" "nic_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

########################
#  Virtual Machine
########################
resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name            # ej: cloudops-vm
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = var.vm_size            # ej: Standard_B1s
  admin_username      = var.admin_username     # ej: cloudops

  # Para acceder con contraseña (en demos). En prod, usar SSH keys.
  disable_password_authentication = false
  admin_password                  = var.admin_password

  network_interface_ids = [azurerm_network_interface.nic.id]

  # Ubuntu 22.04 LTS (Jammy). Puedes cambiar a 20_04-lts si prefieres.
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # cloud-init: ejecuta tu script para instalar Docker y levantar la app
  custom_data = filebase64("${path.module}/user_data.sh")

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  tags = {
    project = "cloudops-orchestrator"
    env     = "demo"
  }
}
