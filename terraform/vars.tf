variable "region" {
  description = "The AWS region to create resources in."
  default = "us-east-1"
}

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

variable "key_name" {
  default = "jenkins"
  description = "SSH key name in your AWS account for AWS instances."
}

variable "vm_user" {
  default = "ec2-user"
}
