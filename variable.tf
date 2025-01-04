variable "vpc_name" {
  description = "Name for VPC"
  type        = string
}

variable "cidr_for_vpc" {
  description = "cidr range for VPC"
  type        = string
}

variable "tenancy" {
  description = "instance tenancy for the instances launced in VPC"
  type        = string
}

variable "dns_hostname_enabled" {
  description = "A boolean flag for enable/disable DNS hostname for VPC"
  type        = bool
}

variable "dns_support_enabled" {
  description = "A boolean flag for enable/disable DNS support for VPC"
  type        = bool
}

variable "web_server_name" {
  type        = string
  description = "Name of Web Server"
}

variable "bastion_host_name" {
  type        = string
  description = "Name of Bastion Host"
}

variable "sshkey" {
  type = string
}

variable "key_name" {
  type        = string
  description = "key pair name"
  default     = "deployer-key"
}

variable "inbound_rule_web" {
  description = "Inbound rules for web server"
  type = list(object({
    port        = number
    description = string
    protocol    = string
    }
  ))
  default = [{
    port        = 22
    description = "Allow ssh from jump server"
    protocol    = "tcp"
    },
    {
      port        = 80
      description = "Allow access on port 80 from ALB"
      protocol    = "tcp"
    }
  ]
}

variable "inbound_rule_app" {
  description = "Inbound rules for app server"
  type = list(object({
    port        = number
    description = string
    protocol    = string
    }
  ))
  default = [
    {
      port        = 8080
      description = "this is for app hosting"
      protocol    = "tcp"
    }
  ]
}

variable "app_server_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "app_server_image_id" {
  type    = string
  default = "ami-01816d07b1128cd2d"
}

variable "db_user_name" {
  type        = string
  description = "user name to connect rds"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "password to connect rds"
  sensitive   = true
}
