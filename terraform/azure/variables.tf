############################
# Variables principales
############################
variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
  default     = "cloudops-rg"
}

variable "location" {
  description = "Región de Azure"
  type        = string
  default     = "westeurope"
}

variable "vnet_name" {
  description = "Nombre de la VNet"
  type        = string
  default     = "cloudops-vnet"
}

variable "vnet_cidr" {
  description = "CIDR de la VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_name" {
  description = "Nombre del Subnet"
  type        = string
  default     = "default"
}

variable "subnet_cidr" {
  description = "CIDR del Subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "vm_name" {
  description = "Nombre de la VM"
  type        = string
  default     = "cloudops-vm"
}

variable "vm_size" {
  description = "Tamaño de la VM"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Usuario administrador de la VM"
  type        = string
  default     = "cloudops"
}

variable "admin_password" {
  description = "Contraseña del admin (solo demo; para prod usa SSH keys)"
  type        = string
  sensitive   = true
  default     = "CloudOps123!."
}

