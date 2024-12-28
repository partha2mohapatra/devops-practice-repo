data "aws_availability_zones" "this" {
  all_availability_zones = true

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_ami" "webserver" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["*-packer-lwp"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}