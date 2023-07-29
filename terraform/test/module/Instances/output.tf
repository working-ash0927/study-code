output "public_ip" {
  value = try(
    aws_instance.this[0].public_ip, # 템플릿에 선언된 순서대로
    aws_spot_instance_request.this[0].public_ip,
    null
  )
}
output "private_ip" {
  value = try(
    aws_instance.this[0].private_ip, # 템플릿에 선언된 순서대로
    aws_spot_instance_request.this[0].private_ip,
    null
  )
}