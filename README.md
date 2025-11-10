# CloudOps Orchestrator 🌩️


Despliegue de una app Dockerizada en **AWS (EC2)** con **Terraform**, CI básico en **GitHub Actions** y *reverse proxy* con **Nginx**. Incluye endpoint `/health` y `/metrics`.


## Stack
- Docker & Docker Compose
- Flask (API demo) + Postgres + Nginx
- Terraform (AWS EC2 + SG)
- GitHub Actions (build + validate)

