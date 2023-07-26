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
    home = {
      description = "ssh allow my home"
      from_port   = null
      to_port     = null
      protocol    = "-1"
      cidr_ipv4   = "14.36.0.0/16"
    }
    company = {
      description = "ssh allow my company"
      from_port   = null
      to_port     = null
      protocol    = "-1"
      cidr_ipv4   = "220.72.0.0/16"
    }
    cafe_ssh = {
      description = "ssh allow my blue-jo cafe"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_ipv4   = "121.141.0.0/16"
    }
    https = {
      description = "https"
      from_port   = null
      to_port     = null
      protocol    = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
}

# security group
resource "aws_security_group" "k8s_master" {
  name        = "k8s_master"
  description = "k8s_master"
  vpc_id      = aws_vpc.main.id
  tags        = local.default_tags
}

# 다른 SG 참조시에 대한 요소를 효과적으로 처리하기 위해. 
resource "aws_vpc_security_group_ingress_rule" "k8s_master" {
  for_each          = local.ingress_rules
  security_group_id = aws_security_group.k8s_master.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_ipv4
  description       = each.value.description
}
resource "aws_vpc_security_group_egress_rule" "k8s_master" {
  security_group_id = aws_security_group.k8s_master.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  #   from_port         = -1
  #   to_port           = -1
}

resource "aws_spot_instance_request" "k8s_master" {
  ami                         = local.arm_ubuntu2204
  instance_type               = "t4g.small"
  key_name                    = "11"
  subnet_id                   = aws_subnet.pub-a.id
  associate_public_ip_address = true
  private_ip                  = cidrhost(aws_subnet.pub-a.cidr_block, 15)

  ## 별도로 운영하는 vpc 내 인스턴스를 생성 시 아래 옵션으로 진행. security_groups로 할 경우 replace로 동작한다
  vpc_security_group_ids = [aws_security_group.k8s_master.id]
  user_data              = file("bash_script/k8s-master.sh")
  lifecycle {
    ignore_changes = [associate_public_ip_address, user_data, ami]
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    tags                  = {}
    volume_size           = 30
    volume_type           = "gp3"
  }
  tags = {
    Name = "k8s_master"
  }
}

output "k8s" {
  value = [
    "pub : ${aws_spot_instance_request.k8s_master.public_ip}",
    "priv : ${aws_spot_instance_request.k8s_master.private_ip}"
  ]
}

resource "aws_spot_instance_request" "k8s_worker1" {
  ami                         = local.arm_ubuntu2204
  instance_type               = "t4g.medium"
  key_name                    = "11"
  subnet_id                   = aws_subnet.pub-a.id
  associate_public_ip_address = true
  private_ip                  = cidrhost(aws_subnet.pub-a.cidr_block, 16)

  ## 별도로 운영하는 vpc 내 인스턴스를 생성 시 아래 옵션으로 진행. security_groups로 할 경우 replace로 동작한다
  vpc_security_group_ids = [aws_security_group.k8s_master.id]
  user_data              = file("bash_script/k8s-worker.sh")
  lifecycle {
    ignore_changes = [associate_public_ip_address, user_data, ami] # spot은 userdata 변경되면 적용할라고 삭제후 생성되기때문
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    tags                  = {}
    volume_size           = 30
    volume_type           = "gp3"
  }
  tags = {
    Name = "k8s_worker1"
  }
}

output "k8s_worker1" {
  value = [
    "pub : ${aws_spot_instance_request.k8s_worker1.public_ip}",
    "priv : ${aws_spot_instance_request.k8s_worker1.private_ip}"
  ]
}

# resource "aws_spot_instance_request" "k8s_worker2" {
#   ami                         = local.arm_ubuntu2204  
#   instance_type               = "t4g.small"
#   key_name                    = "11"
#   subnet_id                   = aws_subnet.pub-a.id
#   associate_public_ip_address = true
#   private_ip                  = cidrhost(aws_subnet.pub-a.cidr_block, 17)

#   ## 별도로 운영하는 vpc 내 인스턴스를 생성 시 아래 옵션으로 진행. security_groups로 할 경우 replace로 동작한다
#   vpc_security_group_ids = [aws_security_group.k8s_master.id]
#   user_data = file("bash_script/k8s-worker.sh")
#   lifecycle {
#     ignore_changes = [associate_public_ip_address, user_data, ami] # spot은 userdata 변경되면 적용할라고 삭제후 생성되기때문
#   }
#   tags = {
#     Name = "k8s_worker2"
#   }
# }

resource "aws_instance" "nfs" {
  ami                         = local.arm_ubuntu2204
  instance_type               = "t4g.nano"
  key_name                    = "11"
  subnet_id                   = aws_subnet.pub-a.id
  associate_public_ip_address = true
  private_ip                  = cidrhost(aws_subnet.pub-a.cidr_block, 200)

  ## 별도로 운영하는 vpc 내 인스턴스를 생성 시 아래 옵션으로 진행. security_groups로 할 경우 replace로 동작한다
  vpc_security_group_ids = [aws_security_group.k8s_master.id]
  user_data              = ""
  lifecycle {
    ignore_changes = [associate_public_ip_address, user_data, ami]
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    tags                  = {}
    volume_size           = 8
    volume_type           = "gp3"
  }
  tags = {
    Name = "nfs"
  }
}

# ## ====================================== ##

# output "k8s_worker2" {
#   value = [
#     "pub : ${aws_spot_instance_request.k8s_worker2.public_ip}", 
#     "priv : ${aws_spot_instance_request.k8s_worker2.private_ip}"
#   ]
# }
output "nfs" {
  value = [
    "pub : ${aws_instance.nfs.public_ip}",
    "priv : ${aws_instance.nfs.private_ip}"
  ]
}
