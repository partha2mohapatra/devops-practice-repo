resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHMcNypiy4jg1N29gJfwYXndxcUYWtTXqnV29Ths5SH partha@Parthas-MacBook-Pro.local"
}