
# resource "aws_security_group" "webserver" {
#   name        = "allow_web_server"
#   description = "Allow web server traffic"
#   vpc_id      = aws_vpc.this.id

#   tags = {
#     Name = "allow_web_server"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4_webserver" {
#   security_group_id = aws_security_group.webserver.id
#   cidr_ipv4         = aws_vpc.this.cidr_block
#   from_port         = 80
#   ip_protocol       = "tcp"
#   to_port           = 80
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_ssh_webserver" {
#   security_group_id = aws_security_group.webserver.id
#   cidr_ipv4         = aws_vpc.this.cidr_block
#   from_port         = 22
#   ip_protocol       = "tcp"
#   to_port           = 22
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_webserver" {
#   security_group_id = aws_security_group.webserver.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }

# resource "aws_security_group" "bastion_host" {
#   name        = "allow_bastion_host"
#   description = "Allow bastion host traffic"
#   vpc_id      = aws_vpc.this.id

#   tags = {
#     Name = "allow_bastion_host"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_ssh_bastion" {
#   security_group_id = aws_security_group.bastion_host.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 22
#   ip_protocol       = "tcp"
#   to_port           = 22
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_bastion" {
#   security_group_id = aws_security_group.bastion_host.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }
