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
          Action   = [
            "ecs:*",
            "ecr:GetAuthorizationToken", 
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
          ]
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

resource "aws_ecs_task_definition" "demo-ecs-task-definition" {
  family                   = "ecs-task-definition-demo"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
  container_definitions    = <<EOF
[
  {
    "name": "demo-container",
    "image": "123456789012.dkr.ecr.us-east-1.amazonaws.com/demo-repo:1.0",
    "memory": 1024,
    "cpu": 512,
    "essential": true,
    "entryPoint": ["/"],
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
    },
         "logConfiguration":{
            "logDriver":"awslogs",
            "options":{
               "awslogs-group":"awslogs-nginx-ecs",
               "awslogs-region":"us-east-1",
               "awslogs-stream-prefix":"ecs"
            }
      ]
    }
  ])
EOF
}

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-1]"
  }
}

resource "aws_cloudwatch_log_group" "bg-challenge4" {
  name = "bg-challenge4"

  tags = {
    Environment = "sre-nonprod"
    Application = "test-demo-challenge"
  }
}