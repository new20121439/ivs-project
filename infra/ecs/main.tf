locals {
  node_app_port = 3000
}

resource "aws_ecs_cluster" "demo-ecs-cluster" {
  name = "ecs-cluster-for-demo"
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "node-app-ecs-task-definition" {
  family                   = "node-app"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  network_mode             = "awsvpc"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "node-app-container"
      image     = var.node_app_image_url
      memory    = 1024
      cpu       = 512
      essential = true
      //      entryPoint = ["/"]
      portMappings = [
        {
          containerPort = local.node_app_port
          hostPort      = local.node_app_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.aws_cloudwatch_log_group //"example-ecs-cluster-group"
          awslogs-stream-prefix = "example-ecs-cluster"
          awslogs-region        = var.region
          awslogs-create-group  = "true"
        }

      }
      healthCheck = null
      // This healthCheck is container healthCheck: node-slim app -> curl not exist
      // If ALB healthCheck can be worked
      //      healthCheck = {
      //        command  = ["CMD-SHELL", "curl -f http://127.0.0.1:${local.node_app_port} || exit 1"]
      //        interval = 40 // 40s. Range: [5s, 300s], Default: 30s
      //        startperiod = "120"
      //        retries = 3
      //        timeout = 5 // 5s. Range: [2s, 60s], Default: 5s
      //      }
      environment = var.node_app_env
    }
  ])
}

resource "aws_ecs_service" "nodejs-ecs-service" {
  name            = "node-app"
  cluster         = aws_ecs_cluster.demo-ecs-cluster.id
  task_definition = aws_ecs_task_definition.node-app-ecs-task-definition.arn
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.ecs_service_network_configuration.subnets
    assign_public_ip = var.ecs_service_network_configuration.assign_public_ip
  }
  desired_count = 1
}
