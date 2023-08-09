variable "create_ebs" {
  type    = bool
  default = false
}
variable "ins_name" {
  type    = string
  default = ""
}
variable "ebs_block_device" {
  type    = map(any)
  default = {}
}
variable "instance_id" {
  type    = string
  default = ""
}

# variable "ebs_encrypted" {
#     type = bool
#     default = false
# }
# variable "ebs_size" {
#     type = number
#     default = null
# }
# variable "ebs_type" {
#     type = string
#     default = "gp3"
# }
# variable "ebs_kms_key_id" {
#     type = string
#     default = null
# }

# variable "ebs_throughput" {
#     type = number
#     default = null
# }

# variable "ebs_tags" {
#   type    = map(string)
#   default = {}
# }
