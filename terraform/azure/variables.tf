variable "project_name"     { type = string }
variable "location"         { type = string }               # ej: "westeurope"
variable "vm_size"          { type = string default = "Standard_B1s" }
variable "admin_username"   { type = string default = "azureuser" }
variable "ssh_public_key"   { type = string }               # contenido de ~/.ssh/cloudops.pub
variable "github_repo_url"  { type = string }               # tu repo
variable "allowed_cidr"     { type = string default = "0.0.0.0/0" } # pon tu IP/32 si quieres más seguro
