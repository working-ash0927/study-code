# password 부분은 Secret Manager 를 활용하는 것을 권고
resource "aws_directory_service_directory" "this" {
  count    = var.create_ad ? 1 : 0
  name     = var.ad_name   # "corp.notexample.com"
  password = var.ad_passwd # "SuperSecretPassw0rd"
  type     = var.ad_type   # "MicrosoftAD"
  edition  = var.ad_edition

  vpc_settings {
    vpc_id     = var.vpc_id
    subnet_ids = var.subnet_ids
  }

  tags = merge(
    {
      "Name" = format("%s", var.ad_name)
    },
    var.tags,
  )
}

resource "aws_vpc_dhcp_options" "this" {
  count               = var.create_ad ? 1 : 0
  domain_name         = var.ad_name
  domain_name_servers = aws_directory_service_directory.this[0].dns_ip_addresses
  # ntp_servers          = ["127.0.0.1"]
  # netbios_name_servers = ["127.0.0.1"]
  netbios_node_type = 2 # Recommand 

  tags = merge(
    {
      "Name" = format("%s", var.ad_name)
    },
    var.tags,
  )
}
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  count           = var.create_ad ? 1 : 0
  vpc_id          = var.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.this[0].id
}