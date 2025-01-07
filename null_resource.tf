resource "null_resource" "provisioner" {
  triggers = {
    always_run = timestamp()
  }

  depends_on = [aws_instance.bastion]

  connection {
    host        = aws_instance.bastion.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = var.sshkey
  }

  # provisioner "local-exec" {
  #   command = "sleep 10 ;scp -o StrictHostKeyChecking=no -i ~/myawskp.pem ~/myawskp.pem ec2-user@${aws_instance.bastion.public_ip}:~"
  # }

  provisioner "file" {
    content     = var.sshkey
    destination = "/home/ec2-user/mykey"
    on_failure  = continue
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod 400 myawskp.pem"
  #   ]
  # }

}