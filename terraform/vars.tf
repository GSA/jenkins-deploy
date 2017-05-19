variable "region" {
  description = "The AWS region to create resources in."
  default = "us-east-1"
}

variable "key_name" {
  default = "jenkins"
  description = "SSH key name in your AWS account for AWS instances."
}
