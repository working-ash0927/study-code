variable "region" {
  type    = string
  default = "ap-northeast-2"
}
# variable "ingress_rule" {
#   type = map(object({
#     description = string
#     from_port   = number
#     to_port     = number
#     protocol    = string
#     cidr_blocks = list(string)
#   }))
# }

variable "create_vpc" {
  type = bool
  default = false
}
variable "enable_nat" {
  type = bool
  default = false
}
variable "vpc_name" {
  type    = string
  default = null
}
variable "vpc_cidr" {
  type    = string
  default = null
}
variable "create_pub_subnet" {
  type = bool
  default = true
}
variable "create_priv_subnet" {
  type = bool
  default = true
}

variable "pub_subnets" {
  type = list
  default = []
}

variable "priv_subnets" {
  type = list
  default = []
}
variable "az" {
  # type = string
  # default = null
  type = list
  default = []
}

variable "nat" {
  type = bool
  default = false
}
variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}