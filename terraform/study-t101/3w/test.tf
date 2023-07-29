# 삼항연산자를 통해 조건 처리 가능.
variable "test" {
    type = string
    default = "1"
}

output "test" {
  value = var.test == "1" ? "true" : "false"
}

variable "is_create" {
  type = bool
  default = false
}

# count와 엮어서 생성 유무를 동적으로 처리할 수 있음
resource "local_file" "createfile" {
  count = var.is_create ? 1 : 0
  content = "im exist!"
  filename = "testfile"
}

#---------------
# 과제1: 조건식 활용해서 리소스 배포 유무 정의
# 과제2: terraform 내장함수를 활용해서 리소스 배포 처리하기 (cidrhost, cidrsubnet 활용하기)
# 과제3: ec2 생성 시 remote-exec/file 프로비저너 혹은 terraform-procider-ansible 을 활용해보기. 간단히 설치 스크립트로 돌려막기 해야겟다
# 과제4: trigger 활용해보기




