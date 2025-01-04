resource "aws_instance" "bastion" {
  ami           = "ami-01816d07b1128cd2d"
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = element([for subnet in aws_subnet.public_subnet : subnet.id], 0)

  tags = {
    Name = var.bastion_host_name
  }
  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]
}