## vpc networks
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}
resource "aws_subnet" "pub-a" {
  vpc_id                                      = aws_vpc.main.id
  cidr_block                                  = var.vpc_pub-a_cidr
  enable_resource_name_dns_a_record_on_launch = true
  availability_zone                           = "${var.region}a"
}
resource "aws_subnet" "priv-a" {
  vpc_id                                      = aws_vpc.main.id
  cidr_block                                  = var.vpc_priv-a_cidr
  enable_resource_name_dns_a_record_on_launch = true
  availability_zone                           = "${var.region}a"
}

# 로컬에 대한 라우팅은 기본적으로 생성되있음. 추가할거만 넣으면 됨
resource "aws_route_table" "pub_route" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table" "priv_route" {
  vpc_id = aws_vpc.main.id
}

# 라우트 테이블에 서브넷 정보 등록
resource "aws_route_table_association" "pub_rt_associate" {
  subnet_id      = aws_subnet.pub-a.id
  route_table_id = aws_route_table.pub_route.id
}

resource "aws_route_table_association" "priv_rt_associate" {
  subnet_id      = aws_subnet.priv-a.id
  route_table_id = aws_route_table.priv_route.id
}