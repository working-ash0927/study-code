variable "a" {
    type = string
  default = "yes"
}
output "if-condition" {
  value = var.a == "yes" ? true : false
}

variable "txt" {
  default   = "im txt"
}

resource "local_file" "foo" {
  content  = upper(var.txt)
  filename = "${path.module}/foo.bar"

  provisioner "local-exec" {  # 프로비저너 중 하나인 로컬 환경에서 명령어를 실행하기 위한 리소스
    command = "echo The content is ${self.content}"  # self는 부모 리소스를 의미
  }

  provisioner "local-exec" {
    command    = "abc"
    on_failure = continue  # 실패해도 다음 명령을 실행해라
  }

  provisioner "local-exec" {
    when    = destroy # 대상 리소스 삭제시 아래 커맨드를 실행
    command = "echo The deleting filename is ${self.filename}"
  }
}
