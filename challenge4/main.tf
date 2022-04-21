terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "challenge4ecs" {
  name = "challenge4ecs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      }
    ]
  })
  inline_policy {
    name = "ssmreadwrite"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["ssm:*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

}

resource "aws_ecr_repository" "challenge4" {
  name = "challenge4"
}

resource "aws_ecr_repository_policy" "challenge4" {
  repository = aws_ecr_repository.challenge4.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
            ]
        }
    ]
}
EOF
}

resource "aws_cloudwatch_log_group" "challenge4" {
  name = "challenge4log"
}

resource "aws_ecs_cluster" "challenge4ecs" {
  name = "challenge4ecs"
}


resource "aws_ecs_service" "challenge4ecs" {
  name            = "challenge4ecs"
  cluster         = aws_ecs_cluster.challenge4ecs.id
  task_definition = aws_ecs_task_definition.challenge4ecs.arn
  desired_count   = 1
  iam_role        = aws_iam_role.challenge4ecs.arn
  depends_on      = [aws_iam_role_policy.challenge4ecs]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
}

resource "aws_ecs_task_definition" "service" {
  family = "service"
  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "service-first"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
    {
      name      = "second"
      image     = "service-second"
      cpu       = 10
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 443
          hostPort      = 443
        }
      ]
    }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-1]"
  }
}

