output "public_ip" {
  value = "${aws_instance.jenkins.public_ip}"
}
