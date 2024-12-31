terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
  }
}

provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::597088052920:role/admin_role"
    session_name = "lwp-session"
  }
  region = "us-east-1"
}