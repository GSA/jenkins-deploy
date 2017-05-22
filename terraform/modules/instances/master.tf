resource "aws_instance" "jenkins" {
  instance_type = "${var.instance_type}"
  # security_groups = ["${aws_security_group.sg_jenkins.name}"]
  security_groups = ["${var.security_groups}"]
  ami = "${var.ami}"
  key_name = "${var.key_name}"

  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "${var.vm_user}"

    # The connection will use the local SSH agent for authentication.
  }

  tags {
    "Name" = "${var.jenkins_name}"
  }

  # force Terraform to wait until a connection can be made, so that Ansible doesn't fail when trying to provision
  provisioner "remote-exec" {
    inline = [
      "echo 'Remote execution connected.'"
    ]
  }
}
