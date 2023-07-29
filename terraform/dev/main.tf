# NIC 삭제 종속성 제거용
# resource "aws_network_interface" "web" {
#   subnet_id       = aws_subnet.pub-a.id
#   private_ips     = ["192.168.1.10"]
#   security_groups = [aws_security_group.allow_all.id]

#   # attachment {
#   #   instance     = aws_instance.test.id
#   #   device_index = 1
#   # }
# }

# resource "aws_spot_instance_request" "web" {
#   # ami = "ami-0caaca55a496a2417"
#   ami = data.aws_ami.amzn2023_arm.image_id
#   instance_type = "t4g.nano"
#   key_name = "11"
#   subnet_id = aws_subnet.pub-a.id
#   associate_public_ip_address = true
#   private_ip = "192.168.1.10"
#   # network_interface {
#   #   network_interface_id = aws_network_interface.web.id
#   #   device_index         = 0
#   # }

#   ## EC2 Classic 및 Default VPC 에서만 사용
#   # security_groups = [aws_security_group.allow_all.id]

#   ## 별도로 운영하는 vpc 내 인스턴스를 생성 시 아래 옵션으로 진행. security_groups로 할 경우 replace로 동작한다
#   vpc_security_group_ids = [aws_security_group.allow_all.id]

#   user_data = <<-EOF
#   #!/bin/bash
#   yum install -y httpd
#   service httpd start
#   systemctl enable start
#   echo "hi, im sanghong" > /var/www/html/index.html
#   EOF
# }
