terraform {


ingress {
description = "HTTP"
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = [var.allowed_cidr]
}


ingress {
description = "SSH"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = [var.allowed_cidr]
}


egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}


# Carga de user_data desde archivo
locals {
user_data = templatefile("${path.module}/user_data.sh", {
github_repo_url = var.github_repo_url
})
}


resource "aws_instance" "app" {
ami = data.aws_ami.ubuntu.id
instance_type = var.instance_type
key_name = var.key_name
vpc_security_group_ids = [aws_security_group.web.id]
associate_public_ip_address = true


user_data = local.user_data


tags = {
Name = var.project_name
}
}