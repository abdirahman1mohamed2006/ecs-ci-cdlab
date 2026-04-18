# ECS-MEMO APPLICATION

## Overview

I created a  end-to-end AWS ECS deployment of a  memo application, built using a multi-build container , Terraform, and GitHub Actions to automate infrastructure and application delivery.

#### Live demo:
 Video not working sorry :(
<img width="1261" height="727" alt="image" src="https://github.com/user-attachments/assets/07e9486e-887a-42d9-8b1c-43db43e07651" />

## Key Features : 

- **Infrastructure as Code** using Terraform  
- **Multi-stage Docker builds** for efficient images  
- **Automated CI/CD** with GitHub Actions and OIDC  
- **ECS Fargate deployment** in private subnets  
- **High availability** across multiple availability zones  

## Architecture:

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/7e25cb43-3803-4f98-9987-c292a7bcb06f" />

### Infrastructure

- **Compute:** AWS ECS Fargate for running containerised applications without managing servers  
- **Networking:** Custom VPC with public and private subnets deployed across multiple availability zones  
- **Outbound Access:** NAT Gateway in public subnets enabling secure internet access from private workloads  
- **Load Balancing:** Application Load Balancer (ALB) handling HTTPS traffic and routing to ECS services  
- **Security:** Workloads isolated in private subnets with controlled access via security groups  
- **DNS & TLS:** Route 53 for domain routing with SSL certificates managed by AWS Certificate Manager (ACM)  
- **Container Registry:** Amazon ECR for storing and managing Docker images  
- **State Management:** Terraform state stored in S3 with versioning, using DynamoDB for state locking

## Repo Structure :


└── ./
    ├── .github
    │   └── workflows
    │       ├── apply.yml
    │       ├── destroy.yml
    │       ├── plan.yml
    │       └── push.yml
    ├── app
    │   └── Dockerfile
    ├── Terraform
    │   ├── modules
    │   │   ├── acm/
    │   │   ├── alb/
    │   │   ├── ecs/
    │   │   ├── route53/
    │   │   ├── security-grps/
    │   │   └── vpc/
    │   ├── main.tf
    │   ├── provider.tf
    │   └── variables.tf
    └── README.md








