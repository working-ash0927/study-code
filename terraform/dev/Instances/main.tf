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

# ## ====================================== ##