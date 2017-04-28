# adapted from https://github.com/shuaibiyy/terraform-jenkins/blob/fa0704f6db4818064f317e98c582581ad08d8e72/main.tf

provider "aws" {
  region = "${var.region}"
}

resource "aws_security_group" "sg_jenkins" {
  name = "sg_${var.jenkins_name}"
  description = "Allows all traffic"

  # SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  # HTTP
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  # HTTPS
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  # Jenkins JNLP port
  ingress {
    from_port = 50000
    to_port = 50000
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_instance" "jenkins" {
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.sg_jenkins.name}"]
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
