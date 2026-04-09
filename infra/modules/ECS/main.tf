
resource "aws_security_group" "ecs_sg" { # this security group directs traffic from the load balancer to the target
  name        = "ecs-sg"
  description = "Allow HTTP inbound traffic from tg to container"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = var.alb_sg_id
  from_port                    = var.port
  to_port                      = var.port
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



# ECS - Service
resource "aws_ecs_service" "memos_service" {
  name            = "memos-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
  subnets = [
    var.public_subnet_1_id,
    var.public_subnet_2_id
  ]
  security_groups  = [aws_security_group.ecs_sg.id]
  assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "memos"
    container_port   = var.port
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_attach
  ]
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
  execution_role_arn       = aws_iam_role.ecs_role.arn
  task_role_arn            = aws_iam_role.ecs_role.arn

  
  container_definitions = jsonencode([
    {
      name      = "memos"
      image     = var.image
      essential = true

      portMappings = [
        {
          containerPort = var.port
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "MEMOS_MODE"
          value = "prod"
        },
        {
          name  = "MEMOS_PORT"
          value = tostring(var.port)
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}