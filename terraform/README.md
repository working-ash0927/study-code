## Terraform 개인 프로젝트 코드
T101 2기 스터디를 통해 알게 된 테라폼 문법을 활용하여 terraform 을 활용한 테스트 환경 인프라를 구축한 코드입니다.
배우는 족족 업데이트 됩니다. 실습코드는 dev 디렉토리 내 파일입니다.

### 목적
1. 테스트를 위해 배포하는 인프라 구성요소를 직접 코드화 및 모듈화.
2. 인프라를 빠르게 삭제, 생성할 수 있는 점을 살려 코드 재사용성을 높히는 용도로 활용

---
### 2023-08-22 업데이트
- FSx Windows FileServer 모듈 추가

### 2023-08-08 업데이트
- AWS Directory Service 활용을 위한 모듈을 추가
- EC2 모듈에서 추가 NIC를 할당할 수 있도록 문법을 개선

### 2023-07-27 업데이트
- Resource 선언 방식의 코드를 Module화 하여 코드의 재사용성을 높혔습니다.

---
## 관리 리소스 (VPC)

#### Root
| **File** | **Block Type** | **Name** | **Info** |
|:---|:---|:---|:---|
| **providor.tf** |  **terraform** |  | Terraform 1.5.2 이상, Backend는 terraform cloud 활용
|                 |   **backend**  |  | local, s3 부분 주석
|   **data.tf**   |    **Data**    | aws_ami | ubuntu2204_arm, amzn2023_arm, ubuntu2204_amd, amzn2023_amd, win2022, win2022_sql
|                 |                | aws_availability_zones | 서울리전 a,c az만 검색
|                 |                | aws_instances | 특정 태그기반 running, stopped 상태 정보 조회
|   **main.tf**   |  **provider**  |  | aws region 정보 명시
|                 |   **locals**   |  | 코드 간소화 및 반복 값 로컬변수 등록
|                 |   **Module**   |  | 실제 구현로직

#### Backend
Terraform Cloud를 활용함으로써 현재 활용중이지 않음
| **Group** | **Block Type** | **Name** | **Info** |
|:---|:---|:---|:---|
| **Storage** | **Resource** | S3       | Managed Terraform tfstate | This is not Module
|             |              | DynamoDB | terraform lock            | This is not Module

#### Network Module
| **Group** | **Block Type** | **Name** | **Info** |
|:---|:---|:---|:---|
| **Networks** | **Resource** | aws_vpc |
|              |              | aws_subnet |
|              |              | aws_internet_gateway |
|              |              | aws_route_table |
|              |              | aws_route_table_association |
|              |              | aws_route | NAT용. 생성 되어있는 라우팅 테이블에 정보 등록을 위해 활용
|              |              | aws_eip | NAT용
|              |              | aws_nat_gateway | NAT용

#### Instances Module
| **Group** | **Block Type** | **Name** | **Info** |
|:---|:---|:---|:---|
| **Compute** | **Resource** | aws_spot_instance_request | 비용절감. Terraform 코드로는 생성 시 태깅이 안됨. 온디멘드와 생성구조 차이가 있음
|             |              | aws_instance | dynamic 블럭으로 ebs 구성이 가능하나, 해당 정보는 terraform에서 관리가 안됨.
|             |              | aws_network_interface | NIC를 별도로 생성후 Attach 하는 경우 랜덤 Public IP 활용 불가
|             |              | aws_eip | Instance 대상 고정아이피 할당
|             |              | aws_eip_association | 

#### EBS Module
| **Group** | **Block Type** | **Name** | **Info** |
|:---|:---|:---|:---|
| **Compute** | **Resource** | aws_ebs_volume
|             |              | aws_volume_attachment
|             |   **Data**   | aws_instances

#### Security Groups Module
| **Group** | **Block Type** | **Name** | **Info** |
|:---|:---|:---|:---|
| **Compute** | **Resource** | aws_security_group
|             |              | aws_vpc_security_group_ingress_rule
|             |              | aws_vpc_security_group_egress_rule

#### Active_Directory Module
해당 모듈 생성 후 제거시, 기존 vpc의 DHCP 기본 구성정보가 재할당 되지 않고 누락되는 점 보완 필요
| **Group** | **Block Type** | **Name** | **Info** |
|:---|:---|:---|:---|
| **Identity** | **Resource** | aws_directory_service_directory | Managed AD
|              |              | aws_vpc_dhcp_options | vpc settings
|              |              | aws_vpc_dhcp_options_association | for AD attach

#### FSx Module
| **Group** | **Block Type** | **Name** | **Info** |
|:---|:---|:---|:---|
| **Identity** | **Resource** | aws_fsx_windows_file_system | 
