# Variables reutilizables que parametrizan el despliegue de infraestructura en Azure mediante Terraform.

# Nombre del grupo de recursos donde se desplegarán todos los recursos de Azure.
variable "resource_group_name" {
  # Valor por defecto: nombre base para el grupo de recursos.
  default = "cloudops-rg"
}

# Región de Azure donde se crearán los recursos (por ejemplo, 'westeurope').
variable "location" {
  # Valor por defecto: Europa occidental (baja latencia y disponibilidad).
  default = "westeurope"
}

# Prefijo común para nombrar los recursos (vnet, subnet, vm, etc.).
variable "prefix" {
  # Facilita la identificación y agrupación de recursos asociados.
  default = "cloudops"
}

# Tamaño de la máquina virtual (SKU). Define CPU, RAM y coste.
variable "vm_size" {
  # 'Standard_B1s' es una instancia económica ideal para entornos de prueba.
  default = "Standard_B1s"
}

# Usuario administrador que se creará en la máquina virtual.
variable "admin_username" {
  # Nombre por defecto para acceder a la VM por SSH o consola.
  default = "cloudops"
}

# Contraseña del usuario administrador.
variable "admin_password" {
  # IMPORTANTE: se recomienda sobrescribir este valor al aplicar Terraform.
  # Puede establecerse mediante 'terraform apply -var "admin_password=MiContraseñaSegura"'
  default = "CloudOps123!"
}
