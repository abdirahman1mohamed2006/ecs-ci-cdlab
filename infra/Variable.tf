variable "domain_name" {
  type    = string
  default = "abdirahman.forum"
}

variable "zone_name" {
  type    = string
  default = "abdirahman.forum"
  }

variable "record_name" {
  type    = string
  default = "app"

}

variable "cluster" {
  type    = string
  default = "abdirahman.cluster"

}

variable "app_name" {
  type = string
  default = "memo-app"
}

variable "lb_name" {
  type    = string
  default = "test-lb-tf"

}

variable "repo_name" {
  type    = string
  default = "ecsmainrepo"

}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "cpu" {
  description = "CPU units for Fargate"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Memory for Fargate"
  type        = string
  default     = "512"
}

variable "app_name_service" {
  type = string
  default = "memo-service"

}

variable "family" {
  type = string
  default = "memo-task"
 }


variable "frontend_port" {
  description = "Frontend container port"
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Backend container port"
  type        = number
  default     = 8081
}

variable "frontend_log_group" {
  type    = string
  default = "/ecs/memo-frontend"
}

variable "backend_log_group" {
  type    = string
  default = "/ecs/memo-backend"
}
# in the .tfvars

variable "frontend_image" {
  type = string
}

variable "backend_image" {
  type = string
}

variable "execution_role_arn" {
  type = string

}

variable "task_role_arn" {
  type = string

}

