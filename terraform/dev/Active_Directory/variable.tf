variable "create_ad" {
  type    = bool
  default = false
}
variable "ad_name" {
  type    = string
  default = null
}
variable "ad_passwd" {
  type      = string
  sensitive = true
}
variable "ad_type" {
  type    = string
  default = "MicrosoftAD"
}
variable "ad_edition" {
  type    = string
  default = "Standard"
}

variable "vpc_id" {
  type    = string
  default = null
}
variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}
