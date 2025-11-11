#  Variables configurables para personalizar la infraestructura desplegada en Azure.

# ------------------------------------------------------------
# Nombre del grupo de recursos que contendrá todos los elementos del proyecto en Azure (redes, VM, IPs, etc.)
# ------------------------------------------------------------
variable "resource_group_name" {
  description = "Nombre del grupo de recursos de Azure"
  default     = "cloudops-rg"
}

# ------------------------------------------------------------
# Región o ubicación donde se desplegarán los recursos.
# ------------------------------------------------------------
variable "location" {
  description = "Región donde se desplegarán los recursos"
  default     = "westeurope"
}

# ------------------------------------------------------------
# Prefijo utilizado como base para nombrar los recursos.
# ------------------------------------------------------------
variable "prefix" {
  description = "Prefijo base para los nombres de recursos"
  default     = "cloudops"
}

# ------------------------------------------------------------
# Nombre del administrador con el que podrás iniciar sesión en la máquina virtual (por SSH o Azure Portal).
# ------------------------------------------------------------
variable "admin_username" {
  description = "Usuario administrador para acceder a la VM"
  default     = "azureuser"
}

# ------------------------------------------------------------
# Contraseña del usuario administrador. Debe cumplir con los requisitos de Azure (mínimo 12 caracteres, mayúsculas, minúsculas, número y símbolo).
# (!!!) NO dejar contraseñas en texto plano, Se pueden pasar como variables de entorno o desde Azure Key Vault.
# ------------------------------------------------------------
variable "admin_password" {
  description = "Contraseña del usuario administrador (mínimo 12 caracteres)"
  default     = "CloudOps1234!"
}

# ------------------------------------------------------------
# Tipo y tamaño de la máquina virtual a desplegar.
# ------------------------------------------------------------
variable "vm_size" {
  description = "Tamaño de la máquina virtual"
  default     = "Standard_B1s"
}