terraform {
  required_version = "~> 1.5.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0, <=5.6.2"
    }
  }
  # backend "local" {  # terraform으로 관리되는 리소스의 정보를 저장하는 위치 지정.
  #   path = "state/terraform.tfstate"
  # }

  backend "s3" {
    bucket         = "9368b2f3d0-tfstate"                    # s3 bucket 이름
    key            = "terraform/study/dev/terraform.tfstate" # s3 내에서 저장되는 경로를 의미합니다.
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

## Terraform을 통해 관리 할 매체를 정의하는 Provider Block
# 호스트 서버에 AWS Credentials를 미리 정의했기 때문에 이 곳에 자격증명 정보를 추가할 필요는 없다.
provider "aws" {
  region = var.region
}


# data "terraform_remote_state" "state" {
#   backend = "local"

#   config = {
#     path = "${path.module}/../../terraform.tfstate"
#   }
# }