provider "aws" {
  region = "${var.region}"
}

module "networking" {
  source = "./modules/networking"
}

module "instances" {
  source = "./modules/instances"
  key_name = "${var.key_name}"
  security_groups = ["${module.networking.sg_name}"]
}
