resource "aws_security_group" "sg_jenkins" {
  name = "${var.sg_name}"
  description = "Allows all traffic"

  # SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.ssh_cidrs}"]
  }

  # HTTP
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["${var.http_cidrs}"]
  }

  # HTTPS
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${var.http_cidrs}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
