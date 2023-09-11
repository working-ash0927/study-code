output "remote_administration_endpoint" {
  value = try(aws_fsx_windows_file_system.this[0].remote_administration_endpoint, null)
}
output deployment_type {
  value = try(aws_fsx_windows_file_system.this[0].deployment_type, null)
}
output dns_name {
  value = try(aws_fsx_windows_file_system.this[0].dns_name, null)
}
output ip {
  value = try(aws_fsx_windows_file_system.this[0].preferred_file_server_ip, null)
}

output storage_info {
  value = try(
    "capacity: ${aws_fsx_windows_file_system.this[0].storage_capacity}, type: ${aws_fsx_windows_file_system.this[0].storage_type}",
    null)
}