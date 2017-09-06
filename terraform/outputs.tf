output "ip" {
  value = "${module.instances.public_ip}"
}

output "instance_id" {
  value = "${module.instances.instance_id}"
}