terraform {
  required_version = "~> 1.5.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0, <=5.6.2"
    }
  }
  cloud {
    organization = "workingash"
    hostname     = "app.terraform.io" # Optional; defaults to app.terraform.io
    workspaces {
      name = "my_tfcloud"
    }
  }
  # backend "local" {  # terraform으로 관리되는 리소스의 정보를 저장하는 위치 지정.
  #   path = "state/terraform.tfstate"
  # }

  # backend "s3" {
  #   bucket         = "9368b2f3d0-tfstate"                    # s3 bucket 이름
  #   key            = "terraform/study/dev/terraform.tfstate" # s3 내에서 저장되는 경로를 의미합니다.
  #   region         = "ap-northeast-2"
  #   encrypt        = true
  #   dynamodb_table = "terraform-lock"
  # }
}
