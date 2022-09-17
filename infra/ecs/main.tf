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
      name       = "node-app-container"
      image      = var.node_app_image_url
      memory     = 1024
      cpu        = 512
      essential  = true
      entryPoint = ["/"]
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
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
