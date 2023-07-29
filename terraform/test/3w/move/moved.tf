# moved 블럭
# 리소스 변경사항에 대해 기본 동작방식은 삭제 후 생성이다. 간혹 생성한 리소스를 변경해야하는 상황이 발생하는데 (count문 for_each로 변경, 모듈화로 인한 참조주소 변경)
# 이미 기입된 state에서 새로운 대상으로 이전 주소와 새 주소로 알리는 역할을 수행함.
# 이전에는 수동으로 state mv 명령으로 지우는 등의 파일을 직접 수정했다면 해당 블럭은 state 파일 접근권한이 없어도 반영할 수 있음.

resource "local_file" "a" {
  content  = "foo!"
  filename = "${path.module}/foo.bar"
}

output "file_content" {
  value = local_file.a.content
}