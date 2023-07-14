# security group
resource "aws_security_group" "allow_all" {
  name = "allow_all"
  description = "allow all traffic"
  vpc_id = aws_vpc.main.id
}
resource "aws_security_group_rule" "ingress_all" {
    type              = "ingress"
    security_group_id = aws_security_group.allow_all.id
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"    
}
resource "aws_security_group_rule" "egress_all" {
    type              = "egress"
    security_group_id = aws_security_group.allow_all.id
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"    
}

resource "aws_instance" "control_plane" {
  # ami = "ami-0caaca55a496a2417"
  ami = data.aws_ami.ubuntu2204_arm.image_id
  instance_type = "t4g.small"
  key_name = "11"
  # subnet_id = aws_subnet.pub-a.id
  associate_public_ip_address = false
  # private_ip = cidrhost(var.vpc_pub-a_cidr, 15)
  hibernation = false

  ## 별도로 운영하는 vpc 내 인스턴스를 생성 시 아래 옵션으로 진행. security_groups로 할 경우 replace로 동작한다
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  user_data = ""
  tags = {
    Name = "tf-k8s-master"
  }
}

resource "aws_network_interface" "control_plane" {
  subnet_id = aws_subnet.pub-a.id
  private_ips = [cidrhost(var.vpc_pub-a_cidr, 15)]
  security_groups = [aws_security_group.allow_all.id]

  attachment {
    instance     = aws_instance.control_plane.id
    device_index = 0
  }
}

resource "aws_eip" "control_plane" {
  domain   = "vpc"
  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_eip_association" "control_plane" {
  instance_id   = aws_instance.control_plane.id
  allocation_id = aws_eip.control_plane.id
}


resource "aws_instance" "nfs" {
  # ami = "ami-0caaca55a496a2417"
  ami = data.aws_ami.ubuntu2204_arm.image_id
  instance_type = "t4g.nano"
  key_name = "11"
  # subnet_id = aws_subnet.pub-a.id
  associate_public_ip_address = false
  # private_ip = cidrhost(var.vpc_pub-a_cidr, 16)
  hibernation = false

  ## 별도로 운영하는 vpc 내 인스턴스를 생성 시 아래 옵션으로 진행. security_groups로 할 경우 replace로 동작한다
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  user_data = ""
  tags = {
    Name = "tf-nfs"
  }
}

resource "aws_network_interface" "nfs" {
  subnet_id = aws_subnet.pub-a.id
  private_ips = [cidrhost(var.vpc_pub-a_cidr, 16)]
  security_groups = [aws_security_group.allow_all.id]

  attachment {
    instance     = aws_instance.nfs.id
    device_index = 0
  }
}

resource "aws_eip" "nfs" {
  domain   = "vpc"
  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_eip_association" "nfs" {
  instance_id   = aws_instance.nfs.id
  allocation_id = aws_eip.nfs.id
}

resource "aws_ec2_instance_state" "control_plane" {
  # for_each = aws_instance.control_plane[*]
  instance_id = aws_instance.control_plane.id
  state = var.ec2-status
}

resource "aws_ec2_instance_state" "nfs" {
  # for_each = aws_instance.nfs[*]
  instance_id = aws_instance.nfs.id
  state = var.ec2-status
}
# ## ====================================== ##
# output "k8_sub_ip" {
#   value = aws_instance.control_plane.public_ip  
# }
# output "k8s_priv_ip" {
#   value = aws_instance.control_plane.private_ip  
# }
# output "nfs_pub_ip" {
#   value = aws_instance.nfs.public_ip  
# }
# output "nfs_priv_ip" {
#   value = aws_instance.nfs.private_ip
# }