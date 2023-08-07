## vpc networks
resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0
  cidr_block = var.vpc_cidr
  tags = merge(
    {
      "Name" = format("%s", var.vpc_name)
    },
    var.tags,
  )
}
resource "aws_internet_gateway" "this" {
  count = var.create_pub_subnet ? 1 : 0
  vpc_id = aws_vpc.this[0].id
}
resource "aws_subnet" "pub" {
  count = var.create_pub_subnet && length(var.pub_subnets) > 0 ? length(var.pub_subnets): 0
  vpc_id                                      = aws_vpc.this[0].id
  cidr_block                                  = var.pub_subnets[count.index]
  enable_resource_name_dns_a_record_on_launch = true
  availability_zone                           = var.az[count.index]
}
resource "aws_subnet" "priv" {
  count = var.create_priv_subnet && length(var.priv_subnets) > 0 ? length(var.priv_subnets): 0
  vpc_id                                      = aws_vpc.this[0].id
  cidr_block                                  = var.priv_subnets[count.index]
  enable_resource_name_dns_a_record_on_launch = true
  availability_zone                           = var.az[count.index]
}

# nat
resource "aws_eip" "nat" {
  count = var.enable_nat && var.create_priv_subnet ? 1 : 0
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat && var.create_priv_subnet ? 1 : 0
  depends_on = [aws_internet_gateway.this]
  allocation_id = try(aws_eip.nat[0].id, null)
  subnet_id     = try(aws_subnet.pub[0].id, null)

  tags = {
    Name = "gw NAT"
  }
}

# 로컬에 대한 라우팅은 기본적으로 생성되있음. 추가할거만 넣으면 됨
resource "aws_route_table" "pub_route" {
  count = var.create_pub_subnet ? 1 : 0
  vpc_id = aws_vpc.this[0].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }
}

# 라우트 테이블에 서브넷 정보 등록
resource "aws_route_table_association" "pub_rt_associate" {
  count = var.create_pub_subnet ? length(var.pub_subnets) : 0
  subnet_id      = element(aws_subnet.pub[*].id, count.index)
  route_table_id = aws_route_table.pub_route[0].id
}

# ==== priv
resource "aws_route_table" "priv_route" {
  count = var.create_priv_subnet ? 1 : 0
  vpc_id = aws_vpc.this[0].id
}

# NAT 고가용성 시 element 사용해서 여러 Route Table 할당할 수 있도록 수정 필요
resource "aws_route" "nat" {
  count = var.create_priv_subnet && var.enable_nat ? 1 : 0
  route_table_id = aws_route_table.priv_route[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.this[0].id
  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "priv_rt_associate" {
  count = var.create_priv_subnet ? length(var.priv_subnets) : 0
  subnet_id      = element(aws_subnet.priv[*].id, count.index)
  route_table_id = aws_route_table.priv_route[0].id
}
