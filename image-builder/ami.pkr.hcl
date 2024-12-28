locals {
  image_name = "${var.app_name}-packer-lwp"
}

source "amazon-ebs" "this" {
  profile       = "devops"
  region        = var.region
  source_ami    = var.image_id
  instance_type = var.instance_type
  ssh_username  = var.ssh_user_name
  ami_name      = local.image_name
}

build {
  sources = [
    "source.amazon-ebs.this"
  ]

  provisioner shell {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "sudo echo '<h1> Welcome to Webserver created by Terraform<h1>'|sudo tee /var/www/html/index.html"
    ]
  }


}
