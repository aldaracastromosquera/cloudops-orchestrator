#  Variables de salida útiles después del despliegue (como la IP pública o el nombre de la VM)

# ------------------------------------------------------------
# Muestra la dirección IP pública asignada a la máquina virtual que permite acceder a la aplicación en la nube desde el navegador (http://IP).
# ------------------------------------------------------------
output "public_ip" {
  description = "Dirección IP pública de la aplicación desplegada"
  value       = azurerm_public_ip.pip.ip_address
}

# ------------------------------------------------------------
# Muestra el nombre de la máquina virtual creada por Terraform.
# Útil para identificar la VM dentro del grupo de recursos o para realizar conexiones SSH si fuera necesario.
# ------------------------------------------------------------
output "vm_name" {
  description = "Nombre de la máquina virtual creada"
  value       = azurerm_linux_virtual_machine.vm.name
}

# ------------------------------------------------------------
# Muestra el nombre del grupo de recursos que contiene todos los elementos desplegados (red, VM, IP, NSG, etc.).
# Permite localizar fácilmente los recursos en el portal de Azure.
# ------------------------------------------------------------
output "resource_group" {
  description = "Nombre del grupo de recursos"
  value       = azurerm_resource_group.rg.name
}
