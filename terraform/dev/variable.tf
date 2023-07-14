variable "region" {
  type    = string
  default = "ap-northeast-2"
}
variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}
variable "vpc_pub-a_cidr" {
  type    = string
  default = "10.20.1.0/24"
}
variable "vpc_priv-a_cidr" {
  type    = string
  default = "10.20.128.0/24"
}

variable "ec2-status" {
  type    = string
  default = "running"
}