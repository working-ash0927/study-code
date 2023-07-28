output "id" {
    value = try(aws_vpc.this[0].id, null)
}
output "pub_subnet_id" {
  value = try( aws_subnet.pub[*].id, null )
}
output "pub_subnet_cidr" {
  value = try( aws_subnet.pub[*].cidr_block, null )
}
output "priv_subnet_id" {
  value = try( aws_subnet.priv[*].id, null )
}
output "priv_subnet_cidr" {
  value = try( aws_subnet.priv[*].cidr_block, null )
}