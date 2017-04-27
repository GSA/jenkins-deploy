output "ip" {
  value = "${aws_instance.jenkins.public_ip}"
}
