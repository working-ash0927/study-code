# # api 호출로 인스턴스 생성 한 뒤 랜덤 발급되는 ip 가져오기
# data "aws_instances" "test" {
#   instance_tags = {
#     IaC = "Terraform"
#   }
#   instance_state_names = ["running", "stopped"]
# }

# Not using on Spot Instance
# resource "aws_network_interface" "this" {
#   count = var.create_instance && !var.create_spot_instance ? 1 : 0
#   subnet_id       = var.subnet_id
#   private_ips     = var.private_ips
#   security_groups = var.vpc_security_group_ids
#   source_dest_check = var.source_dest_check # nat, Openswan ...
#   tags = merge(
#     {
#       "Name" = format("%s", var.ins_name)
#     },
#     var.tags,
#   )
# }
# resource "aws_network_interface_attachment" "this" {
#   count = local.nic_create_flag
#   instance_id          = var.create_instance && !var.create_spot_instance ? aws_instance.this[0].id : aws_spot_instance_request.this[0].id
#   network_interface_id = aws_network_interface.this[0].id
#   device_index         = 0
# }

resource "aws_eip" "this" {
  # count = (local.nic_create_flag == 1) && var.create_eip ? 1 : 0
  count      = (var.create_instance || var.create_spot_instance) && var.create_eip ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_instance.this, aws_spot_instance_request.this]
}
resource "aws_eip_association" "eip_assoc" {
  # count = (local.nic_create_flag == 1) && var.create_eip ? 1 : 0
  count = (var.create_instance || var.create_spot_instance) && var.create_eip ? 1 : 0
  # network_interface_id = aws_network_interface.this[0].id
  instance_id   = var.create_instance && !var.create_spot_instance ? aws_instance.this[0].id : aws_spot_instance_request.this[0].id
  allocation_id = aws_eip.this[0].id
}

#### NIC test ####
# resource "aws_instance" "this" {
#   count                       = var.create_instance && !var.create_spot_instance ? 1 : 0
#   ami                         = var.ami
#   instance_type               = var.instance_type               # "t4g.small"
#   key_name                    = var.key_name                    # "11"
#   # associate_public_ip_address = var.associate_public_ip_address # nic 따로 쓰면 활용 불가
#   get_password_data           = var.get_password_data           # for windows
#   user_data              = var.user_data

#   network_interface {
#     network_interface_id = aws_network_interface.this[0].id
#     device_index         = 0
#     delete_on_termination = false
#     # associate_public_ip_address = false
#   }

#   lifecycle {
#     ignore_changes = [
#       user_data, ami
#       # public_ip, private_ip, subnet_id
#     ]
#   }
#   root_block_device {
#     delete_on_termination = var.root_volume_delete_on_termination #true
#     encrypted             = var.root_volume_encrypted             #false
#     volume_size           = var.root_volume_size                  #30
#     volume_type           = var.root_volume_type                  #"gp3"
#     tags                  = var.root_volume_tags
#   }

#   dynamic "ebs_block_device" {
#     for_each = var.ebs_block_device

#     content {
#       delete_on_termination = try(ebs_block_device.value.delete_on_termination, null)
#       device_name           = ebs_block_device.value.device_name
#       encrypted             = try(ebs_block_device.value.encrypted, null)
#       iops                  = try(ebs_block_device.value.iops, null)
#       kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
#       snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
#       volume_size           = try(ebs_block_device.value.volume_size, null)
#       volume_type           = try(ebs_block_device.value.volume_type, null)
#       throughput            = try(ebs_block_device.value.throughput, null)
#       tags                  = try(ebs_block_device.value.tags, null)
#     }
#   }
#   tags = merge(
#     {
#       "Name" = format("%s", var.ins_name)
#     },
#     var.tags,
#   )
# }

# resource "aws_spot_instance_request" "this" {
#   count                       = var.create_spot_instance ? 1 : 0
#   ami                         = var.ami
#   instance_type               = var.instance_type
#   key_name                    = var.key_name
#   associate_public_ip_address = var.associate_public_ip_address
#   get_password_data           = var.get_password_data # for windows
#   private_ip = var.private_ip
#   user_data              = var.user_data
#   lifecycle {
#     ignore_changes = [
#       associate_public_ip_address, user_data, ami,
#       # tags, public_ip, private_ip, subnet_id
#     ]
#   }
#   root_block_device {
#     delete_on_termination = var.root_volume_delete_on_termination #true
#     encrypted             = var.root_volume_encrypted             #false
#     volume_size           = var.root_volume_size                  #30
#     volume_type           = var.root_volume_type                  #"gp3"
#     tags                  = var.root_volume_tags
#   }

#   dynamic "ebs_block_device" {
#     for_each = var.ebs_block_device

#     content {
#       delete_on_termination = try(ebs_block_device.value.delete_on_termination, null)
#       device_name           = ebs_block_device.value.device_name
#       encrypted             = try(ebs_block_device.value.encrypted, null)
#       iops                  = try(ebs_block_device.value.iops, null)
#       kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
#       snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
#       volume_size           = try(ebs_block_device.value.volume_size, null)
#       volume_type           = try(ebs_block_device.value.volume_type, null)
#       throughput            = try(ebs_block_device.value.throughput, null)
#       tags                  = try(ebs_block_device.value.tags, null)
#     }
#   }
#   tags = merge(
#     {
#       "Name" = format("%s", var.ins_name)
#     },
#     var.tags,
#   )
# }

resource "aws_instance" "this" {
  count                       = var.create_instance && !var.create_spot_instance ? 1 : 0
  ami                         = var.ami
  instance_type               = var.instance_type               # "t4g.small"
  key_name                    = var.key_name                    # "11"
  subnet_id                   = var.subnet_id                   # aws_subnet.pub-a.id
  associate_public_ip_address = var.associate_public_ip_address # true
  private_ip                  = var.private_ip                  # cidrhost(aws_subnet.pub-a.cidr_block, 15)
  get_password_data           = var.get_password_data           # for windows

  ## 별도로 운영하는 vpc 내 인스턴스를 생성 시 아래 옵션으로 진행. security_groups로 할 경우 replace로 동작한다
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = var.user_data
  lifecycle {
    ignore_changes = [
      user_data, ami,
      # associate_public_ip_address
      # public_ip, private_ip, subnet_id
    ]
  }
  root_block_device {
    delete_on_termination = var.root_volume_delete_on_termination #true
    encrypted             = var.root_volume_encrypted             #false
    volume_size           = var.root_volume_size                  #30
    volume_type           = var.root_volume_type                  #"gp3"
    tags                  = var.root_volume_tags
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device

    content {
      delete_on_termination = try(ebs_block_device.value.delete_on_termination, null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = try(ebs_block_device.value.encrypted, null)
      iops                  = try(ebs_block_device.value.iops, null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = try(ebs_block_device.value.volume_size, null)
      volume_type           = try(ebs_block_device.value.volume_type, null)
      throughput            = try(ebs_block_device.value.throughput, null)
      tags                  = try(ebs_block_device.value.tags, null)
    }
  }
  tags = merge(
    {
      "Name" = format("%s", var.ins_name)
    },
    var.tags,
  )
}

resource "aws_spot_instance_request" "this" {
  count                       = var.create_spot_instance ? 1 : 0
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = var.private_ip
  get_password_data           = var.get_password_data # for windows

  ## 별도로 운영하는 vpc 내 인스턴스를 생성 시 아래 옵션으로 진행. security_groups로 할 경우 replace로 동작한다
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = var.user_data
  lifecycle {
    ignore_changes = [
      associate_public_ip_address, user_data, ami,
      # tags, public_ip, private_ip, subnet_id
    ]
  }
  root_block_device {
    delete_on_termination = var.root_volume_delete_on_termination #true
    encrypted             = var.root_volume_encrypted             #false
    volume_size           = var.root_volume_size                  #30
    volume_type           = var.root_volume_type                  #"gp3"
    tags                  = var.root_volume_tags
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device

    content {
      delete_on_termination = try(ebs_block_device.value.delete_on_termination, null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = try(ebs_block_device.value.encrypted, null)
      iops                  = try(ebs_block_device.value.iops, null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = try(ebs_block_device.value.volume_size, null)
      volume_type           = try(ebs_block_device.value.volume_type, null)
      throughput            = try(ebs_block_device.value.throughput, null)
      tags                  = try(ebs_block_device.value.tags, null)
    }
  }
  tags = merge(
    {
      "Name" = format("%s", var.ins_name)
    },
    var.tags,
  )
}


# NIC ## ====================================== ##
resource "aws_network_interface" "this" {
  count           = (var.create_instance || var.create_spot_instance) && length(var.extend_nic_ips) > 0 ? 1 : 0
  subnet_id       = var.subnet_id
  private_ips     = var.extend_nic_ips
  security_groups = var.vpc_security_group_ids

  attachment {
    instance = try(
      aws_instance.this[0].id,
      aws_spot_instance_request.this[0].id,
      null
    )
    device_index = count.index + 1
  }
}