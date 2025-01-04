
resource "aws_security_group" "webserver_sg" {
  name        = "allow_access_web_server"
  description = "Allow web server traffic"
  vpc_id      = aws_vpc.this.id

  dynamic "ingress" {
    for_each = var.inbound_rule_web
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      description = ingress.value.description
      protocol    = ingress.value.protocol
      cidr_blocks = [aws_vpc.this.cidr_block]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web_server_sg"
  }
}


resource "aws_security_group" "bastion_host_sg" {
  name        = "allow_ssh_bastion_host"
  description = "Allow bastion host traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_bastion_host_sg"
  }
}

resource "aws_security_group" "appserver_sg" {
  name        = "allow_access_app_server"
  description = "Allow app server traffic"
  vpc_id      = aws_vpc.this.id

  dynamic "ingress" {
    for_each = var.inbound_rule_app
    content {
      from_port       = ingress.value.port
      to_port         = ingress.value.port
      description     = ingress.value.description
      protocol        = ingress.value.protocol
      security_groups = [aws_security_group.webserver_sg.id]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web_server_sg"
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "allow_lb"
  description = "Allow lb traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "allow access to alb from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_alb_sg"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "allow_db"
  description = "Allow db traffic from app server"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "allow access to db from app server"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.appserver_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_db_sg"
  }
}