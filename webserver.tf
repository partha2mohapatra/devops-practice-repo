resource "aws_instance" "webserver" {
  ami           = data.aws_ami.webserver.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = element([for subnet in aws_subnet.private_subnet : subnet.id], 0)

  tags = {
    Name = var.web_server_name
  }
  vpc_security_group_ids = [aws_security_group.webserver.id]
  # user_data              = file("${path.module}/user_data.sh")
}

resource "aws_security_group" "webserver" {
  name        = "allow_web_server"
  description = "Allow web server traffic"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "allow_web_server"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4_webserver" {
  security_group_id = aws_security_group.webserver.id
  cidr_ipv4         = aws_vpc.this.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_webserver" {
  security_group_id = aws_security_group.webserver.id
  cidr_ipv4         = aws_vpc.this.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_webserver" {
  security_group_id = aws_security_group.webserver.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
