terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.37.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket       = "ecs-project-terraform-state-65980864122-eu-west-1"
    encrypt      = true
    key          = "./terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}



provider "aws" {
  # Configuration options
}