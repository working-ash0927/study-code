# security group
resource "aws_security_group" "this" {
  count                  = var.create_sg ? 1 : 0
  name                   = var.sg_name
  description            = var.sg_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete
  tags = merge(
    {
      "Name" = format("%s", var.sg_name)
    },
    var.tags,
  )
  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}
# 다른 SG 참조시에 대한 요소를 효과적으로 처리하기 위해. 
resource "aws_vpc_security_group_ingress_rule" "this" {
  count             = var.create_sg ? length(var.ingress_rule) : 0
  security_group_id = aws_security_group.this[0].id

  from_port = lookup(
    var.ingress_rule[count.index],
    "from_port",
    null
  )
  to_port = lookup(
    var.ingress_rule[count.index],
    "to_port",
    null
  )
  ip_protocol = lookup(
    var.ingress_rule[count.index],
    "ip_protocol",
    ""
  )
  cidr_ipv4 = lookup(
    var.ingress_rule[count.index],
    "cidr_ipv4",
    "0.0.0.0/0"
  )
  description = lookup(
    var.ingress_rule[count.index],
    "description",
    "Not Define"
  )
}
resource "aws_vpc_security_group_egress_rule" "this" {
  count             = var.create_sg ? length(var.egress_rule) : 0
  security_group_id = aws_security_group.this[0].id

  from_port = lookup(
    var.egress_rule[count.index],
    "from_port",
    null
  )
  to_port = lookup(
    var.egress_rule[count.index],
    "to_port",
    null
  )
  ip_protocol = lookup(
    var.egress_rule[count.index],
    "ip_protocol",
    "-1"
  )
  cidr_ipv4 = lookup(
    var.egress_rule[count.index],
    "cidr_ipv4",
    "0.0.0.0/0"
  )
  description = lookup(
    var.egress_rule[count.index],
    "description",
    "Not Define"
  )
}

# resource "aws_vpc_security_group_egress_rule" "this" {
#   security_group_id = aws_security_group.this[0].id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1"
#   #   from_port         = -1
#   #   to_port           = -1
# }