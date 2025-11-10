SHELL := /bin/bash


.PHONY: up down logs ps fmt lint


up:
docker compose up -d --build


logs:
docker compose logs -f --tail=100


ps:
docker compose ps


down:
docker compose down -v


fmt:
terraform -chdir=terraform/aws fmt


lint:
terraform -chdir=terraform/aws validate