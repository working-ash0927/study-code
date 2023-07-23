data "aws_availability_zones" "azs" {
  state = "available"
}
locals {
  azs = slice(data.aws_availability_zones.azs.names, 0, 2)
}

module "vpc" {
  source = "./networks"
  craete_vpc = true
  vpc_cidr = "192.168.0.0/16"
  pub_subnets = [for i in range(2) : cidrsubnet(var.vpc_cidr, 8, i + 1)]
  priv_subnets = [for i in range(2) : cidrsubnet(var.vpc_cidr, 8, i + 128)]
  az = local.azs
}
