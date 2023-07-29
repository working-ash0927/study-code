provider "aws" {
  region = "ap-northeast-2"
}

locals {
  vpc_cidr = "192.168.0.0/16"
  azs      = slice(data.aws_availability_zones.azs.names, 0, 2)

  arm_ubuntu2204 = data.aws_ami.ubuntu2204_arm.image_id
  arm_amazon2023 = data.aws_ami.amzn2023_arm.image_id
  x86_ubuntu2204 = data.aws_ami.ubuntu2204_amd.image_id
  x86_amazon2023 = data.aws_ami.amzn2023_amd.image_id

  default_tags = {
    IaC         = "Terraform"
    Environment = "Dev"
  }
  egress_rules = [
    {
      description = "k8s_master"
      from_port   = null
      to_port     = null
      protocol    = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  ]
}

module "vpc" {
  source       = "./Networks"
  create_vpc   = true
  vpc_cidr     = local.vpc_cidr
  vpc_name     = "terraform"
  pub_subnets  = [for i in range(2) : cidrsubnet(local.vpc_cidr, 8, i + 1)]
  priv_subnets = [for i in range(2) : cidrsubnet(local.vpc_cidr, 8, i + 128)]
  az           = local.azs
}
module "sg_all_allow" {
  source         = "./Security_group"
  create_sg      = true
  vpc_id         = module.vpc.id
  sg_name        = "k8s_master"
  sg_description = "k8s_master"
  ingress_rule = [
    {
      description = "vpc_allow_all"
      from_port   = null
      to_port     = null
      ip_protocol = "-1"
      cidr_ipv4   = local.vpc_cidr
      }, {
      description = "ssh allow my home"
      from_port   = null
      to_port     = null
      ip_protocol = "-1"
      cidr_ipv4   = "14.36.0.0/16"
      }, {
      description = "ssh allow my company"
      from_port   = null
      to_port     = null
      ip_protocol = "-1"
      cidr_ipv4   = "220.72.0.0/16"
      }, {
      description = "ssh allow my blue-jo cafe"
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      cidr_ipv4   = "121.141.0.0/16"
      }, {
      description = "https"
      from_port   = null
      to_port     = null
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  ]
  egress_rule = local.egress_rules
  tags        = local.default_tags
}
locals {
  k8s_info = {

  }
}

module "k8s_control_plane" {
  source                      = "./Instances"
  create_spot_instance        = false
  ins_name                    = "k8s_control_plane"
  ami                         = local.arm_ubuntu2204
  instance_type               = "t4g.small"
  key_name                    = "11"
  subnet_id                   = module.vpc.pub_subnet_id[0]
  associate_public_ip_address = true
  private_ip                  = cidrhost(module.vpc.pub_subnet_cidr[0], 15)
  vpc_security_group_ids      = [module.sg_all_allow.id]
  user_data                   = file("bash_script/k8s-master.sh")
  root_volume_size            = 30
  tags                        = local.default_tags
}

module "k8s_worker1" {
  source                      = "./Instances"
  create_spot_instance        = false
  ins_name                    = "k8s_worker1"
  ami                         = local.arm_ubuntu2204
  instance_type               = "t4g.medium"
  key_name                    = "11"
  subnet_id                   = module.vpc.pub_subnet_id[0]
  associate_public_ip_address = true
  private_ip                  = cidrhost(module.vpc.pub_subnet_cidr[0], 16)
  vpc_security_group_ids      = [module.sg_all_allow.id]
  user_data                   = file("bash_script/k8s-master.sh")
  root_volume_size            = 30
  tags                        = local.default_tags
}

module "nfs" {
  source          = "./Instances"
  # create_instance = true
  create_spot_instance        = false
  ins_name                    = "nfs"
  ami                         = local.arm_ubuntu2204
  instance_type               = "t4g.nano"
  key_name                    = "11"
  subnet_id                   = module.vpc.pub_subnet_id[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.sg_all_allow.id]
  private_ip                  = cidrhost(module.vpc.pub_subnet_cidr[0], 200)
  tags                        = local.default_tags
}