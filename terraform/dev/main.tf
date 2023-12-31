provider "aws" {
  region = "ap-northeast-2"
}

locals {
  vpc_cidr = "192.168.0.0/16"
  azs      = slice(data.aws_availability_zones.azs.names, 0, 2)

  arm_ubuntu2204  = data.aws_ami.ubuntu2204_arm.image_id
  arm_amazon2023  = data.aws_ami.amzn2023_arm.image_id
  x86_ubuntu2204  = data.aws_ami.ubuntu2204_amd.image_id
  x86_amazon2023  = data.aws_ami.amzn2023_amd.image_id
  x86_win2022     = data.aws_ami.win2022.image_id
  x86_win2022_sql = data.aws_ami.win2022_sql.image_id

  default_tags = {
    IaC         = "Terraform"
    Environment = "Dev"
  }
}

module "vpc" {
  source     = "./Networks"
  create_vpc = true
  vpc_cidr   = local.vpc_cidr
  vpc_name   = "terraform"
  # enable_nat   = true
  pub_subnets  = [for i in range(2) : cidrsubnet(local.vpc_cidr, 8, i + 1)]
  priv_subnets = [for i in range(2) : cidrsubnet(local.vpc_cidr, 8, i + 128)]
  # enable_nat = true
  az           = local.azs
}
module "sg_workspace" {
  source         = "./Security_group"
  create_sg      = true
  vpc_id         = module.vpc.id
  sg_name        = "mytest"
  sg_description = "mytest"
  ingress_rule = [
    {
      description = "vpc_allow_all"
      from_port   = null
      to_port     = null
      ip_protocol = "-1"
      cidr_ipv4   = local.vpc_cidr
      }, {
      description = "allow my home"
      from_port   = null
      to_port     = null
      ip_protocol = "-1"
      cidr_ipv4   = "14.36.0.0/16"
      }, {
      description = "allow my company"
      from_port   = null
      to_port     = null
      ip_protocol = "-1"
      cidr_ipv4   = "220.72.0.0/16"
      }, {
      description = "ssh anywhere"
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  ]
  # egress_rule = []
  tags        = local.default_tags
}
locals {
  ebs_block_device = {
    d = {
      availability_zone = "ap-northeast-2a"
      encrypted         = false
      size              = 10
      type              = "gp3"
      kms_key_id        = null
      throughput        = null
      tags              = null
      device_name       = "/dev/sda2"
    }
    # e = {
    #     availability_zone = "ap-northeast-2a"
    #     encrypted = false
    #     size = 6
    #     type = "gp3"
    #     kms_key_id = null
    #     throughput = null
    #     tags = null
    #     device_name = "/dev/sda3"
    # }
  }
}

module "simple_ad" {
  source     = "./Active_Directory"
  # create_ad  = true
  ad_name    = "sanghong.com"
  ad_passwd  = "Qlalfqjsgh123#"
  vpc_id     = module.vpc.id
  subnet_ids = module.vpc.pub_subnet_ids
  tags       = local.default_tags
}

module "win_fsx" {
  source = "./FSx"
  # create_fsx_windows = true
  active_directory_id = module.simple_ad.id
  # 현재 2개 고정이라 이래 하는데, 변경 필요한지는 체크
  subnet_ids = module.vpc.priv_subnet_ids
  deployment_type = "MULTI_AZ_1"
  preferred_subnet_id = module.vpc.priv_subnet_ids[0]
  security_group_ids = [ module.sg_workspace.id ]
}

module "ansible" {
  source = "./Instances"
  # create_instance = true  
  # create_eip = true
  # create_spot_instance        = true 
  associate_public_ip_address = true # nic 별도로 생성하면 활용 불가. 인스턴스 자체 생성시에만 활용되기 떄문
  ins_name                    = "t"
  ami                         = local.arm_ubuntu2204
  instance_type               = "t4g.micro"
  key_name                    = "11"
  subnet_id                   = module.vpc.pub_subnet_ids[0]
  private_ip                  = cidrhost(module.vpc.pub_subnet_cidr[0], 10)
  vpc_security_group_ids = [module.sg_workspace.id]
  root_volume_size       = 8
  user_data = file("bash_script/install-ansible.sh")
  tags                   = local.default_tags
}

module "test" {
  count = 2
  source = "./Instances"
  # create_instance = true  
  # create_eip = true
  # create_spot_instance        = true 
  associate_public_ip_address = true # nic 별도로 생성하면 활용 불가. 인스턴스 자체 생성시에만 활용되기 떄문
  ins_name                    = "test${count.index}"
  ami                         = local.arm_ubuntu2204
  instance_type               = "t4g.nano"
  key_name                    = "11"
  subnet_id                   = module.vpc.pub_subnet_ids[0]
  private_ip                  = cidrhost(module.vpc.pub_subnet_cidr[0], 20 + count.index)
  vpc_security_group_ids = [module.sg_workspace.id]
  root_volume_size       = 8
  user_data = file("bash_script/create_user.sh")
  tags                   = local.default_tags
}

module "jump" {
  source     = "./Instances"
  depends_on = [module.simple_ad]
  # create_instance = true
  # create_eip = true
  # create_spot_instance        = true
  associate_public_ip_address = true # nic 별도로 생성하면 활용 불가. 인스턴스 자체 생성시에만 활용되기 떄문
  ins_name                    = "jump"
  get_password_data           = true
  ami                         = local.x86_win2022
  instance_type               = "t3a.medium"
  key_name                    = "11-win"
  subnet_id                   = module.vpc.pub_subnet_ids[0]
  private_ip                  = cidrhost(module.vpc.pub_subnet_cidr[0], 10)
  vpc_security_group_ids      = [module.sg_workspace.id]
  root_volume_size            = 30
  tags                        = local.default_tags
}

module "failover-windows" {
  count      = 2
  depends_on = [module.simple_ad]
  source     = "./Instances"
  # create_instance = true
  # create_eip = true
  # create_spot_instance        = true
  associate_public_ip_address = true # nic 별도로 생성하면 활용 불가. 인스턴스 자체 생성시에만 활용되기 떄문
  ins_name                    = "server${count.index}"
  get_password_data           = true
  ami                         = local.x86_win2022_sql
  instance_type               = "c5a.large"
  key_name                    = "11-win"
  subnet_id                   = element(module.vpc.pub_subnet_ids[*], count.index)
  private_ip                  = cidrhost(element(module.vpc.pub_subnet_cidr[*], count.index), count.index + 11)
  extend_nic_ips = [ # failover vip
    cidrhost(element(module.vpc.pub_subnet_cidr[*], count.index), 101),
    cidrhost(element(module.vpc.pub_subnet_cidr[*], count.index), 102)
  ]
  vpc_security_group_ids = [module.sg_workspace.id]
  root_volume_size       = 65
  tags                   = local.default_tags
}

# 수정필요. 여러개 선언하면 왠지 모르게 인스턴스에 여러개 생성해서 attach가 안됨
module "extend_ebs" {
  source           = "./EBS"
  depends_on       = [module.test]
  # create_ebs       = true
  ebs_block_device = local.ebs_block_device
  ins_name         = "test"
}

# module "k8s_control_plane" {
#   source                      = "./Instances"
#   create_spot_instance        = false
#   ins_name                    = "k8s_control_plane"
#   ami                         = local.arm_ubuntu2204
#   instance_type               = "t4g.small"
#   key_name                    = "11"
#   subnet_id                   = module.vpc.pub_subnet_ids[0]
#   associate_public_ip_address = true
#   private_ip                  = cidrhost(module.vpc.pub_subnet_cidr[0], 15)
#   vpc_security_group_ids      = [module.sg_workspace.id]
#   user_data                   = file("bash_script/k8s-master.sh")
#   root_volume_size            = 30
#   tags                        = local.default_tags
# }

# module "k8s_worker1" {
#   source                      = "./Instances"
#   create_spot_instance        = false
#   ins_name                    = "k8s_worker1"
#   ami                         = local.arm_ubuntu2204
#   instance_type               = "t4g.medium"
#   key_name                    = "11"
#   subnet_id                   = module.vpc.pub_subnet_ids[0]
#   associate_public_ip_address = true
#   private_ip                  = cidrhost(module.vpc.pub_subnet_cidr[0], 16)
#   vpc_security_group_ids      = [module.sg_workspace.id]
#   user_data                   = file("bash_script/k8s-master.sh")
#   root_volume_size            = 30
#   tags                        = local.default_tags
# }

# module "nfs" {
#   source          = "./Instances"
#   # create_instance = true
#   create_spot_instance        = false
#   ins_name                    = "nfs"
#   ami                         = local.arm_ubuntu2204
#   instance_type               = "t4g.nano"
#   key_name                    = "11"
#   subnet_id                   = module.vpc.pub_subnet_ids[0]
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [module.sg_workspace.id]
#   private_ip                  = cidrhost(module.vpc.pub_subnet_cidr[0], 200)
#   tags                        = local.default_tags
# }