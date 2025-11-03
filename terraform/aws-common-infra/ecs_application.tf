resource "aws_ecs_cluster" "ecs_app_cluster" {
  name = "${var.name_prefix}-${var.environment}-cluster"

  tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

# ECS Task Definition
resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${var.name_prefix}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "${var.name_prefix}-${var.environment}-container"
    image     = "${aws_ecr_repository.ecs_app_ecr_repo.repository_url}:latest"
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = 8080
      protocol      = "tcp"
    }]
  }])
}

resource "aws_ecs_service" "ecs_app_service" {
  name            = "${var.name_prefix}-${var.environment}-service"
  cluster         = aws_ecs_cluster.ecs_app_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.network.private_subnet_ids
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_app_alb_tg.arn
    container_name   = "${var.name_prefix}-${var.environment}-container"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.http_listener, aws_lb_target_group.ecs_app_alb_tg]
}
