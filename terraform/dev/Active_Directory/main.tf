resource "aws_directory_service_directory" "this" {
    count = var.create_ad ? 1 : 0
  name     = var.ad_name# "corp.notexample.com"
  password = var.ad_passwd # "SuperSecretPassw0rd"
  size     = var.ad_size # "Small"

  vpc_settings {
    vpc_id     = var.vpc_id
    subnet_ids = var.subnet_ids
  }

#   tags = {
#     Project = "foo"
#   }
}