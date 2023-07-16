
## 동적으로 ec2 이미지를 가장 최신 버전으로 불러오는 data block
data "aws_ami" "amzn2023_arm" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-arm64"]
  }
}

data "aws_ami" "amzn2023_amd" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

data "aws_ami" "ubuntu2204_arm" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server*"]
  }
}
data "aws_ami" "ubuntu2204_amd" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"]
  }
}

data "aws_availability_zones" "azs" {
  state = "available"
}