resource "aws_ecr_repository" "ecsmainrepo" { # creates the repo . 
  name                 = var.repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = var.repo_name
  }
}

resource "aws_ecr_lifecycle_policy" "ecslife" { # Removes any images in repo

  repository = aws_ecr_repository.ecsmainrepo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Remove any images older than 10 days"
        selection = {
          tagStatus   = "any"
          countType   = "sinceImagePushed"
          "countUnit" = "days"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}