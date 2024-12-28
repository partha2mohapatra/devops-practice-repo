#Create VPC
resource "aws_vpc" "this" {
  cidr_block       = var.cidr_for_vpc
  instance_tenancy = var.tenancy

  tags = {
    Name = var.vpc_name
  }
}

#Create Public Subnet
resource "aws_subnet" "public_subnet" {
  for_each                = { for index, az_name in slice(data.aws_availability_zones.this.names, 0, 2) : index => az_name }
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_for_vpc, length(data.aws_availability_zones.this.names) > 3 ? 4 : 3, each.key)
  availability_zone       = each.value
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-Subnet-${each.key}"
  }
}

#Create Private Subnet
resource "aws_subnet" "private_subnet" {
  for_each                = { for index, az_name in slice(data.aws_availability_zones.this.names, 0, 2) : index => az_name }
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_for_vpc, length(data.aws_availability_zones.this.names) > 3 ? 4 : 3, each.key + length(data.aws_availability_zones.this.names))
  availability_zone       = each.value
  map_public_ip_on_launch = true
  tags = {
    Name = "Private-Subnet-${each.key}"
  }
}

#Create Default/private Subnet Route Table
resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "private-rt-${var.vpc_name}"
  }
}

#Create prublic subnet Route Table
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "public-rt-${var.vpc_name}"
  }

}

#Create Internet Gateway for Public Subnet
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "aws_internet_gateway-${var.vpc_name}"
  }
}

# Associate Route table with Private subnet
resource "aws_route_table_association" "private_subnet_association" {
  for_each       = { for i, each_subnet in aws_subnet.private_subnet : i => each_subnet.id }
  subnet_id      = each.value
  route_table_id = aws_default_route_table.this.id
}

# Associate default Route table with public subnet
resource "aws_route_table_association" "public_subnet_association" {
  for_each       = { for i, each_subnet in aws_subnet.public_subnet : i => each_subnet.id }
  subnet_id      = each.value
  route_table_id = aws_route_table.this.id
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "this" {
  domain = "vpc"
}


# Create NAT Gateway under one public subnet
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = element([for each_subnet in aws_subnet.public_subnet : each_subnet.id], 0)

  tags = {
    Name = "NAT-${var.vpc_name}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.this]
}



################## Other Methods #####################



### Method-1
# resource "aws_subnet" "this" {
#   for_each   = { "pub-1" : "192.168.0.0/27", "pub-2" : "192.168.0.32/27", "pvt-1" : "192.168.0.64/27", "pvt-2" : "192.168.0.96/27" }
#   vpc_id     = aws_vpc.this.id
#   cidr_block = each.value
#   tags = {
#     Name = "Subnet-${each.key}"
#   }
# }


### Method-2
# resource "aws_subnet" "this" {
#   count   = no_of_subnets
#   vpc_id     = aws_vpc.this.id
#   cidr_block = element(cidr_subnet, count.index)
#   tags = {
#     Name = "Subnet-${count.index}"
#   }
# }

# variable "no_of_subnets" {
#  type =  number
#  description = "Number of Subnets to be created"
#  default = 4
# }

# variable "cidr_subnet" {
#  type =  list(string)
#  description = "list of cidr range for subnet"
#  default = ["192.168.0.0/27", "192.168.0.32/27", "192.168.0.64/27", "192.168.0.96/27"]
# }

### Method-3
# resource "aws_subnet" "this" {
#   count      = length(var.cidr_subnet)
#   vpc_id     = aws_vpc.this.id
#   cidr_block = element(var.cidr_subnet, count.index)
#   tags = {
#     Name = "Subnet-${count.index+1}"
#   }
# }

# variable "cidr_subnet" {
#   type        = list(string)
#   description = "list of cidr range for subnet"
#   default     = ["192.168.0.0/27", "192.168.0.32/27", "192.168.0.64/27", "192.168.0.96/27"]
# }

# resource "aws_subnet" "sn_az1" {
#   for_each          = { "pub-1_az1" : "192.168.0.0/27", "pvt-1_az1" : "192.168.0.64/27" }
#   vpc_id            = aws_vpc.this.id
#   availability_zone = "us-east-1a"
#   cidr_block        = each.value
#   tags = {
#     Name = "Subnet-${each.key}"
#   }
# }

# resource "aws_subnet" "sn_az2" {
#   for_each          = { "pub-2_az2" : "192.168.0.32/27", "pvt-2_az2" : "192.168.0.96/27" }
#   vpc_id            = aws_vpc.this.id
#   availability_zone = "us-east-1b"
#   cidr_block        = each.value
#   tags = {
#     Name = "Subnet-${each.key}"
#   }
# }
