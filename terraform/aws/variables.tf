t_name" { type = string }
variable "aws_region" { type = string }
variable "instance_type" { type = string }
variable "key_name" { type = string }
variable "github_repo_url" { type = string }
variable "allowed_cidr" { type = string default = "0.0.0.0/0" }