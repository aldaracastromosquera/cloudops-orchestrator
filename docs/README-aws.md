# AWS Notes


- EC2 Ubuntu 22.04 LTS
- SG: abre 22 (SSH) y 80 (HTTP) — restringe `allowed_cidr` en `terraform.tfvars`.
- `user_data`:
- instala docker + compose
- clona repo y `docker compose up -d`
- crea `systemd` unit para persistencia en reinicios