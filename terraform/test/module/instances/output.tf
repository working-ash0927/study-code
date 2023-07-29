output "public_ip" {
  value = try(
    aws_spot_instance_request.this[*].public_ip,
    aws_instance.this[*].public_ip,
    null
  )
  # value = aws_instance.this.*
}
output "private_ip" {
  value = try(
    aws_spot_instance_request.this[*].private_ip,
    aws_instance.this[*].private_ip,
    null
  )
  # value = aws_instance.this.*
}