# output "t" {
#     # t = { a = A, b= B}
#   value = { for k,v in local.ebs_block_device : k => v}
# }

data "aws_instances" "this" {
  filter {
    name = "tag:Name"
    values = [var.ins_name]
  }
  instance_state_names = ["running", "stopped"]
}

resource "aws_ebs_volume" "this" {
    # count = var.create_ebs ? length(var.ebs_block_device) : 0
    for_each = var.create_ebs && length(var.ebs_block_device) > 0 ? {for k,v in var.ebs_block_device : k => v} : {}
    availability_zone = try(each.value.availability_zone, null)
    encrypted = try(each.value.encrypted, null)
    size = try(each.value.size, null)
    type = try(each.value.type, "gp3")
    kms_key_id = try(each.value.kms_key_id, null)
    throughput = try(each.value.throughput, null)
    tags = try(each.value.tags, null)
    # final_snapshot = var.ebs_final_snapshot
    # iops = var.ebs_iops
    # multi_attach_enabled = var.ebs_multi_attach_enabled
}
resource "aws_volume_attachment" "this" {
  for_each = var.create_ebs && length(var.ebs_block_device) > 0 ? {for k,v in var.ebs_block_device : k => v} : {}
  device_name = each.value.device_name
  volume_id   = aws_ebs_volume.this[each.key].id
  instance_id = try(join(",", data.aws_instances.this.ids), null) # for_each 는 배열 쓸수없음
#   instance_id = var.instance_id
}