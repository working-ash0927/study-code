terraform {
  required_version = "~> 1.5.2" # 1.5.x 버전의 Terraform만 활용 가능
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0, <=5.6.2" # 5.0 ~ 5.6.2 버전의 프로바이더만 사용 가능
    }
  }
  backend "local" { # terraform으로 관리되는 리소스의 정보를 저장하는 위치 지정.
    path = "state/terraform.tfstate"
  }
}

## Terraform을 통해 관리 할 매체를 정의하는 Provider Block
# 호스트 서버에 AWS Credentials를 미리 정의했기 때문에 이 곳에 자격증명 정보를 추가할 필요는 없다.
# provider "aws" {
#   region = var.region
# }