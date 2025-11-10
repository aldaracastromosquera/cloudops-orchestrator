output "public_ip" {
value = aws_instance.app.public_ip
}


output "app_url" {
value = "http://${aws_instance.app.public_ip}"
}