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
- AWS Directory Service 활용을 위한 모듈을 추가하였습니다.
- EC2 모듈에서 추가 NIC를 할당할 수 있도록 문법을 개선하였습니다.

### 2023-07-27 업데이트
- Resource 선언 방식의 코드를 Module화 하여 코드의 재사용성을 높혔습니다.

---
### 관리 리소스 (VPC)

#### Backend
| **Group** | **Block Type** | **Name** | **Info** |
|:---|:---|:---|:---|
| **Storage** | **Resource** | S3       | Managed Terraform tfstate | This is not Module
|             |              | DynamoDB | terraform lock            | This is not Module

#### Network Module
| **Group** | **Block Type** | **Name** | **Info** |
|:---|:---|:---|:---|
| **Networks** | **Resource** | VPC | BaseNetwork
|              |              | Subnet |
|              |              | RouteTable |
|              |              | RouteTable Associate |
|              |              | InternetGateway |
|              |   **Data**   | aws_availability_zones |

#### Instances Module
| **Group** | **Block Type** | **Name** | **Info** |
|:---|:---|:---|:---|
| **Compute** | **Resource** | Spot Instance | Saving my Cost
|             |              | On-demand Instance
|             |              | Security Groups
|             |   **Data**   | aws_ami | ubuntu2204_arm, amzn2023_arm, ubuntu2204_amd, amzn2023_amd, win2022, win2022_sql

#### Active_Directory Module
| **Group** | **Block Type** | **Name** | **Info** |
|:---|:---|:---|:---|
| **Identity** | **Resource** | aws_directory_service_directory | Managed AD
|              |              | aws_vpc_dhcp_options | vpc settings
|              |              | aws_vpc_dhcp_options_association | for AD attach

#### FSx Module
| **Group** | **Block Type** | **Name** | **Info** |
|:---|:---|:---|:---|
| **Identity** | **Resource** | aws_fsx_windows_file_system | for FCI Failover Cluster 
