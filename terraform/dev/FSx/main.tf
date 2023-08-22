# 관리형
resource "aws_fsx_windows_file_system" "this" {
  count               = var.create_fsx_windows ? 1 : 0
  active_directory_id = var.active_directory_id
  preferred_subnet_id = var.preferred_subnet_id 
  deployment_type = var.deployment_type
  kms_key_id          = var.kms_key_id       # optional
  storage_capacity    = var.storage_capacity #30
  subnet_ids          = var.subnet_ids
  throughput_capacity = var.throughput_capacity #8 minimum
  security_group_ids  = var.security_group_ids
  storage_type        = var.storage_type # default HDD
  skip_final_backup = var.skip_final_backup
  lifecycle {
    ignore_changes = [security_group_ids]
  }
}