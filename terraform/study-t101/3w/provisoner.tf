# --- 프로비저너
# 사용자 편리성땜에 terraform 구문으로 관리할 순 있으나, 이는 tfstate에 저장되지 않음. (멱등성 제공 x, 비권장)
# 실패하지 않을 데이터 처리에 가끔 활용하는것도 괜찮을 듯 함
# apply 하면서 동작이 어떻게 하는지 검토해보자.

variable "txt" {
  default   = "secret"
  #sensitive = true
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

# null 리소스는 리소스 블럭으로 정의된 별도의 데이터. 이로 인해 각 리소스의 의존성 해소를 하면서 별도 작업을 수행할 수 있음.
# 다만 이렇게 실행된 데이터 정보는 state 에서 id 값으로만 확인됨
resource "null_resource" "example1" {
  
  provisioner "local-exec" {
    command = <<EOF
      echo Hello!! > file.txt
      echo $ENV >> file.txt
      EOF
    
    interpreter = [ "bash" , "-c" ]

    working_dir = "/tmp"

    environment = {
      ENV = "world!!"
    }
  }
}

# connection 블록으로 원격지 연결 정의. 보안취약점이 있기때문에 이는 비권장.
resource "null_resource" "example2" {
  
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = var.host
  }

  provisioner "file" {
    source      = "conf/myapp.conf"
    destination = "/etc/myapp.conf"
  }

  provisioner "file" { # 원격지에서 타 서버로 파일 전송시 활용
    source      = "conf/myapp.conf"
    destination = "C:/App/myapp.conf"

    connection {
        type     = "winrm"
        user     = "Administrator"
        password = var.admin_password
        host     = var.host
    }
  }
}

# terraform_data는 null_resource를 대체하기 위해 나옴. 별도 프로바이더 구성이 필요가 없고 (null_resource는 terraform init -upgrade 해줘야함 )
# null_resource와 동작하는건 거의 동일함. 위에 언급은 안됐지만 null_resource 리소스는 한번 실행 후 재실행하기 위해서는 trigger 로 강제 재실행 유도를 해주어야 함
# terraform_data는 trigger_replace로 강제 재실행 가능.
resource "terraform_data" "foo" {
  triggers_replace = [
    aws_instance.foo.id,
    aws_instance.bar.id
  ]

  input = "world"
}

output "terraform_data_output" {
  value = terraform_data.foo.output  # 출력 결과는 "world"
}
