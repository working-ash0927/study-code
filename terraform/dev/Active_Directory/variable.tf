variable "create_ad" {
    type = bool
    default = false
}
variable "ad_name" {
  type = string
  default = null
}
variable "ad_passwd" {
  type = string
  sensitive = true
}
variable "ad_size" {
    type = string
    default = "Small"
}
variable "vpc_id" {
    type = string
    default = null
}
variable "subnet_ids" {
    type = list(string)
    default = []
}