resource "aws_instance" "webserver" {
  ami           = data.aws_ami.webserver.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = element([for subnet in aws_subnet.private_subnet : subnet.id], 0)

  tags = {
    Name = var.web_server_name
  }
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  # user_data              = file("${path.module}/user_data.sh")
}