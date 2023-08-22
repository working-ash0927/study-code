variable "create_fsx_windows" {
  type    = bool
  default = false
}
variable "active_directory_id" {
  type = string
  default = null
}
variable "deployment_type" {
  type = string
  default = null # MULTI_AZ_1, SINGLE_AZ_1, SINGLE_AZ_2. Default value is SINGLE_AZ_1.
}
# multi_az_1 사용시 기본 az 지정용
variable preferred_subnet_id {
  type = string
  default = null
}
variable "kms_key_id" {
  type    = string
  default = null # default aws/fsx arn
}
variable "storage_capacity" {
  type    = number
  default = 32 # 32 -65535
}
variable "subnet_ids" {
  type    = list(string)
  default = null
}
variable "throughput_capacity" {
  type    = number
  default = 8 # minimum
}
variable "security_group_ids" {
  type    = list(string)
  default = null
}
variable "storage_type" {
  type    = string
  default = "SSD" # default HDD
}
variable "skip_final_backup" {
  type = bool
  default = true
}