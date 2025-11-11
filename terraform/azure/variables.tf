#  Variables configurables para personalizar la infraestructura desplegada en Azure.

variable "resource_group_name" {
  type        = string
  description = "Nombre del grupo de recursos de Azure"
  default     = "cloudops-rg"
}

variable "location" {
  type        = string
  description = "Región de Azure donde se desplegará la infraestructura"
  default     = "westeurope"
}

variable "prefix" {
  type        = string
  description = "Prefijo para nombrar los recursos"
  default     = "cloudops"
}

variable "vm_size" {
  type        = string
  description = "Tamaño de la máquina virtual"
  default     = "Standard_B1s"
}

variable "admin_username" {
  type        = string
  description = "Nombre de usuario administrador de la VM"
  default     = "azureuser"
}

variable "admin_password" {
  type        = string
  description = "Contraseña del usuario administrador"
  default     = "ContraseñaSegura123!"
  sensitive   = true
}
