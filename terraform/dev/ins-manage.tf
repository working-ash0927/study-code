# variable "docker-init" {
#   default = "20230721"
# }

# resource "terraform_data" "docker-install" {
#   triggers_replace = [
#     var.docker-init
#   ]
#   connection {
#     type        = "ssh"
#     user        = "ec2-user"
#     private_key = file("11.pem")
#     host        = aws_spot_instance_request.whale.public_ip
#   }
#   provisioner "remote-exec" {
#     inline = [
#       "sudo usermod -aG docker ec2-user",
#       "sudo yum install -y docker",
#       "sudo service docker start",
#       "sudo systemctl enable docker"
#     ]
#   }
# }

# variable "nfs_init" {
#   default = "20230723"
# }
# resource "terraform_data" "nfs-install" {
#   triggers_replace = [
#     var.nfs_init
#   ]
#   connection {
#     type        = "ssh"
#     user        = "ubuntu"
#     private_key = file("11.pem")
#     host        = aws_instance.nfs.public_ip
#   }
#   provisioner "remote-exec" {
#     inline = [
#         "node1=${aws_instance.k8s_master.private_ip}; node2=${aws_spot_instance_request.k8s_worker1.private_ip}; node3=${aws_spot_instance_request.k8s_worker2.private_ip}",
#         "sudo apt update",
#         "sudo apt-get install nfs-common nfs-kernel-server portmap -y",
#         "sudo mkdir /home/nfs",
#         "sudo chmod 777 /home/nfs",
#         "# NFS 활용 권한 구성",
#         "echo -e \"/home/nfs $node1(rw,sync,no_subtree_check) $node2(rw,sync,no_subtree_check) $node3(rw,sync,no_subtree_check)\" >> /etc/exports",
#         "sudo service nfs-server restart"
#     ]
#   }
# }

# resource "aws_ec2_instance_state" "k8s_master" {
#   instance_id = aws_instance.k8s_master.id
#   state       = "running"
# #   state       = "stopped"
# }

# resource "aws_ec2_instance_state" "nfs" {
#   instance_id = aws_instance.nfs.id
#   state       = "running"
# #   state       = "stopped"
# }