variable "sg_name" {
  default = "sg_jenkins"
  description = "Security group name"
}

variable "http_cidrs" {
  default = ["0.0.0.0/0"]
  description = "CIDRs for accessing the instance via HTTP(S)."
}

variable "ssh_cidrs" {
  default = ["0.0.0.0/0"]
  description = "CIDRs for accessing the instance via SSH."
}
