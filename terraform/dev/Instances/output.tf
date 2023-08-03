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
# output "public_ip" {
#   value = try(
#     data.aws_instances.test.public_ips,
#     null
#   )
# }
# output "private_ip" {
#   value = try(
#     data.aws_instances.test.private_ips,
#     null
#   )
# }
output "get_win_pw" {
  value = try(
    rsadecrypt(aws_instance.this[0].password_data, file("/Users/ash/Downloads/keys/11-win.pem")),
    rsadecrypt(aws_spot_instance_request.this[0].password_data, file("/Users/ash/Downloads/keys/11-win.pem")),
    null
  )
}