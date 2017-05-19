provider "aws" {
  region = "${var.region}"
}

module "standalone" {
  source = "./modules/standalone"
}
