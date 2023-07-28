### instance ###
variable "create_instance" {
  type    = bool
  default = false
}
variable "create_spot_instance" {
  type    = bool
  default = false
}
variable "ami" {
  type    = string
  default = ""
}
variable "instance_type" {
  type    = string
  default = ""
}
variable "key_name" {
  type    = string
  default = ""
}
variable "subnet_id" {
  type    = string
  default = ""
}
variable "associate_public_ip_address" {
  type    = bool
  default = false
}
variable "private_ip" {
  type    = string
  default = ""
}

variable "get_password_data" { # for windows
  description = "If true, wait for password data to become available and retrieve it"
  type        = bool
  default     = null
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead"
  type        = string
  default     = null
}
variable "root_volume_delete_on_termination" {
  type    = bool
  default = true
}
variable "root_volume_encrypted" {
  type    = bool
  default = false
}
variable "root_volume_size" {
  type    = number
  default = 8
}
variable "root_volume_type" {
  type    = string
  default = "gp3"
}
variable "root_volume_tags" {
  type    = map(string)
  default = {}
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(any)
  default     = []
}
variable "ins_name" {
  description = "instance name tag"
  type        = string
  default     = ""
}
variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}