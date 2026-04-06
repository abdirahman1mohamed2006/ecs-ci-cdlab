
resource "aws_security_group" "ecs_sg" { # this security group directs traffic from the load balancer to the target
  name        = "ecs-sg"
  description = "Allow HTTP inbound traffic from tg to container"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = var.alb_sg_id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "ecs_all_out" {
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Ecs cluster - This is to ensure the fargate has a place to mananage my service

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster
}

# cloudwatch - so my container logs go somehwere 

resource "aws_cloudwatch_log_group" "ecs" {
  name              = var.app_name
  retention_in_days = 7
}

#IAM  execution role so ECS can pull your image from ECR and send longs to the cloudwatch

resource "aws_iam_role" "ecs_role" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "ecs_attach" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Task definition - so ECS Knows which docker image to run , what port to use and how much cpu and memory for it to be given . 

resource "aws_ecs_task_definition" "task" {
  family                   = var.family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = var.backend_image
      essential = true

      environment = [
        {
          name  = "MEMOS_MODE"
          value = "prod"
        },
        {
          name  = "MEMOS_DRIVER"
          value = "postgres"
        }
      ]

      portMappings = [
        {
          containerPort = var.backend_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.backend_log_group
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    },
    {
      name      = "frontend"
      image     = var.frontend_image
      essential = true

      dependsOn = [
        {
          containerName = "backend"
          condition     = "START"
        }
      ]

      portMappings = [
        {
          containerPort = var.frontend_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.frontend_log_group
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# ECS service - This is in order to make sure the task stays running and it connectss to the target group . 

resource "aws_ecs_service" "mongo" {
  name            = var.app_name_service
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  health_check_grace_period_seconds = 60

  network_configuration {
    subnets          = [var.private_subnet_1_id, var.private_subnet_2_id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "frontend"
    container_port   = 80
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_attach]
}







