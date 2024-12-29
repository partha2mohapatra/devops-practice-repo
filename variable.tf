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
  type        = string
}