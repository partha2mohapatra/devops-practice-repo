output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [for each_subnet in aws_subnet.public_subnet : each_subnet.id]
}

output "private_subnet_ids" {
  value = [for each_subnet in aws_subnet.private_subnet : each_subnet.id]
}