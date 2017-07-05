variable "jenkins_name" {
  description = "The name of the Jenkins server."
  default = "jenkins"
}

variable "ami" {
  # RHEL 7.0 (HVM)
  # https://aws.amazon.com/marketplace/pp/B00KWBZVK6
  default = "ami-a8d369c0"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "iam_instance_profile" {
  default = ""
}

# networking
variable "vpc_security_group_ids" {
  type = "list"
}
variable "subnet_id" {
  type = "string"
}

variable "key_name" {
  default = "jenkins"
  description = "SSH key name in your AWS account for AWS instances."
}

variable "vm_user" {
  default = "ec2-user"
}
