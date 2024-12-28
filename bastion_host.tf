resource "aws_instance" "bastion" {
  ami           = "ami-01816d07b1128cd2d"
  instance_type = "t2.micro"
  key_name      = "myawskp"
  subnet_id     = element([for subnet in aws_subnet.public_subnet : subnet.id], 0)

  tags = {
    Name = var.bastion_host_name
  }
  vpc_security_group_ids = [aws_security_group.bastion_host.id]
}

resource "aws_security_group" "bastion_host" {
  name        = "allow_bastion_host"
  description = "Allow bastion host traffic"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "allow_bastion_host"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_bastion" {
  security_group_id = aws_security_group.bastion_host.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_bastion" {
  security_group_id = aws_security_group.bastion_host.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
