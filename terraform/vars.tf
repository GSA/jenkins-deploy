variable "region" {
  description = "The AWS region to create resources in."
  default = "us-east-1"
}

variable "jenkins_name" {
  description = "The name of the Jenkins server."
  default = "jenkins"
}

variable "ami" {
  # RHEL 7.0
  default = "ami-a8d369c0"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "jenkins"
  description = "SSH key name in your AWS account for AWS instances."
}
