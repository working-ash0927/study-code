## Terraform T101 2기 스터디 관련 개인 프로젝트 코드
스터디를 통해 알게 된 지식을 바탕으로 terraform 을 활용한 테스트 환경 인프라를 구축한 코드입니다.

### 목적
1. Kubernetes 를 VM에 띄워 공부하였으나, 집의 Desktop에 한정되어 공부하는게 불편하여 클라우드에 운영하고 싶었음.
2. 인프라는 빠르게 삭제할 수 있고, 빠르게 추가할 수 있었으면 하여 스터디 수강과 함께 terraform으로 관리하기로 함.


### 2023-07-27 특징
- Resource 선언 방식의 코드를 Module화 하여 코드의 재사용성을 높혔습니다.


### 관리 리소스 (VPC)
--------
| **Type** | **Group** | **Resource Name** | **info** |
|:---|:---|:---|:---|
| **Network** | **Resource** | VPC | BaseNetwork
|             |             | Subnet |
|             |             | RouteTable |
|             |             | RouteTable Associate |
|             |             | InternetGateway |
|             | **Data**    | aws_availability_zones |
| **Compute** | **Resource** | Spot Instance | Saving my Cost
|             |             | On-demand Instance |
|             |             | Security Groups |
|             | **Data**    |  aws_ami |
| **Storage** | **Resource** | S3 | Managed Terraform tfstate |
|              |             | DynamoDB | terraform lock |


