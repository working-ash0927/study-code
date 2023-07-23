provider "aws" {
  region = "ap-northeast-2"
}

locals {
    arm_ubuntu2204 = data.aws_ami.ubuntu2204_arm.image_id
    arm_amazon2023 = data.aws_ami.amzn2023_arm.image_id
    x86_ubuntu2204 = data.aws_ami.ubuntu2204_amd.image_id
    x86_amazon2023 = data.aws_ami.amzn2023_amd.image_id
    default_tags = {
        manage = "Terraform"
    }
    ingress_rules = {
        vpc = {
            description = "vpc_allow_all"
            from_port   = null
            to_port     = null
            protocol    = "-1"
            cidr_ipv4   = var.vpc_cidr
        }
        home_ssh = {
            description = "ssh allow my home"
            from_port   = null
            to_port     = null
            protocol    = "-1"
            cidr_ipv4   = "14.36.0.0/16"
        }
    }
    k8s = {
        control_plane = {

        }
    }
}



# module "k8s_control_plane" {
#   source = "./instances"
# }


# module "k8s_control_plane" {
#   source = "./instances"
# }

