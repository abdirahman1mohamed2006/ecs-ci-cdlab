variable "vpc_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "private_subnet_1_id" {
  type = string
}

variable "private_subnet_2_id" {
  type = string
}

variable "cluster" {
  type = string
  default = "memo_cluster"
}

variable "app_name" {
  type = string
  default = "memo-app"
}

variable "app_name_service" {
  type    = string
  default = "memo-service"
}

variable "family" {
  type    = string
  default = "memo-task"
}

variable "cpu" {
  type    = string
  default = "256"
}

variable "memory" {
  type    = string
  default = "512"
}

variable "frontend_image" {
  type = string
}

variable "backend_image" {
  type = string
}

variable "frontend_port" {
  type    = number
  default = 80
}

variable "backend_port" {
  type    = number
  default = 8080
}

variable "target_group_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "frontend_log_group" {
  type = string
}

variable "backend_log_group" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}