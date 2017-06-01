provider "aws" {
  region = "${var.region}"
}

data "aws_region" "current" {
  current = true
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

module "networking" {
  source = "./modules/networking"

  vpc_id = "${data.aws_vpc.default.id}"
}

module "instances" {
  source = "./modules/instances"

  key_name = "${var.key_name}"
  # pick first subnet in default VPC, arbitrarily
  subnet_id = "${element(data.aws_subnet_ids.all.ids, 0)}"
  vpc_security_group_ids = ["${module.networking.sg_id}"]
}
