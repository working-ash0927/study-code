variable "region" {
  type    = string
  default = "ap-northeast-2"
}
variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"
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

# variable "k8s_master-status" {
#   type    = string
#   default = "running"
#   # default = "stopped" 
# }
# variable "nfs-status" {
#   type    = string
#   default = "running"
#     # default = "stopped" 
# }

variable "k8s-init" {
  type    = string
  default = "20230718"
}