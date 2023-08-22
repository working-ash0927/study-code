output "addresses" {
  value = try(aws_directory_service_directory.this[0].dns_ip_addresses, null)
}
output "id" {
  value = try(aws_directory_service_directory.this[0].id, null)
}