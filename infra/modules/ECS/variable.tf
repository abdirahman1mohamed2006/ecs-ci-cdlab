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



variable "image" {
  type = string
}

variable "port" {
  type    = number
  default = 5230
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



variable "log_group" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}