variable "create_sg" {
  type    = bool
  default = true
}
variable "sg_name" {
  type    = string
  default = null
}
variable "sg_description" {
  type    = string
  default = "Security Group managed by Terraform"
}
variable "vpc_id" {
  type    = string
  default = null
}
variable "revoke_rules_on_delete" {
  type    = bool
  default = false
}
variable "ingress_rule" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}
variable "egress_rule" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = [
    {
      description = "egress-all"
      from_port   = null
      to_port     = null
      protocol    = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  ]
}

variable "create_timeout" {
  type    = string
  default = "10m"
}
variable "delete_timeout" {
  type    = string
  default = "15m"
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}