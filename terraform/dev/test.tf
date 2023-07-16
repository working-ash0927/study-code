# # locals {
# #     default_settings = {
# #         ami = data.aws_ami.ubuntu2204_arm.id
# #         # aza = data.aws_availability_zones.azs.names[0]
# #         azc = data.aws_availability_zones.azs.names[2]
# #     }
# # }

# # resource "local_file" "test" {
# #     for_each = local.default_settings
# #     content = "${each.key} : ${each.value}"
# #     filename = each.key
# # }

# # locals {
# #     names = ["ami", "azc"]
# #     default_settings = [
# #         data.aws_ami.ubuntu2204_arm.id,
# #         # data.aws_availability_zones.azs.names[0],
# #         data.aws_availability_zones.azs.names[2]
# #     ]
# # }
# # resource "local_file" "test" {
# #     count = 2
# #     content = local.default_settings[count.index]
# #     filename = local.names[count.index]
# # }

# locals {
#     loop_test1 = ["a", "b", "c"]
#     loop_test2 = {
#         ami = data.aws_ami.ubuntu2204_arm.id
#         aza = data.aws_availability_zones.azs.names[0]
#         azc = data.aws_availability_zones.azs.names[2]
#     }
# }

# output "t1" {
#   value = [for v in local.loop_test1 : upper(v)]
# }
# output "t2" {
#   value = [for i,v in local.loop_test1 : "index: ${i} value: ${upper(v)}"]
# }
# output "t3" {
#   value = { for v in local.loop_test2 : v  => upper(v)}
# }

# variable "members" {
#   type = map(object({
#     role = string 
#   }))
#   default = {
#     ab = { role = "member", group = "dev" }
#     cd = { role = "admin", group = "dev" }
#     ef = { role = "member", group = "ops" }
#   }
# }
# output "A_to_tuple" {
#   value = [for k, v in var.members: "${k} is ${v.role}"]
# }

# output "B_get_only_role" {
#   value = {
#     for name, user in var.members: name => user.role
#     if user.role == "admin"
#   }
# }

# output "C_group" {
#   value = {
#     for name, user in var.members: user.role => name...
#   }
# }

# variable "names" {
#   default = {
#     a = "hello a"
#     b = "hello b"
#     c = "hello c"
#   }
# }

# data "archive_file" "dotfiles" {
#   type        = "zip"
#   output_path = "${path.module}/dotfiles.zip"

#   dynamic "source" {
#     for_each = var.names
#     content {
#       content  = source.value
#       filename = "${path.module}/${source.key}.txt"
#     }
#   }
# }