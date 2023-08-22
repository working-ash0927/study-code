output "fsx_windows" {
  value = try(aws_fsx_windows_file_system.this[*], null)
}