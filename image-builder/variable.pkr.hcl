variable region {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}


variable instance_type {
  description = "Instance Type to launch"
  type        = string
  default     = "t2.micro"
}

variable ssh_user_name {
  description = "ssh user namemfor instance"
  type        = string
  default     = "ec2-user"
}

variable app_name {
  description = "app name for webserver image"
  type        = string
  default     = "web-server-image"
}

variable image_id {
  description = "image id for web server ami"
  type        = string
  default     = "ami-01816d07b1128cd2d"
}