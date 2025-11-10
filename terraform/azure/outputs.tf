output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "app_url" {
  value = "http://${azurerm_public_ip.pip.ip_address}"
}