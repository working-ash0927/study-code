output "ad" {
    value = try(aws_directory_service_directory.this[0], null)
}