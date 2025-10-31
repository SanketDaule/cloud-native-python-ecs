resource "aws_lb" "ecs_app_alb" {
  name               = "${var.name_prefix}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_app_alb_sg.id]
  subnets            = module.network.public_subnet_ids

  enable_deletion_protection = false

  tags = merge(
    {
      Name        = "${var.name_prefix}-${var.environment}-alb"
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

resource "aws_lb_target_group" "ecs_app_alb_tg" {
  name        = "${var.name_prefix}-${var.environment}-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = module.network.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.ecs_app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_app_alb_tg.arn
  }
}

resource "aws_security_group" "ecs_app_alb_sg" {
  name   = "${var.name_prefix}-${var.environment}-alb-sg"
  vpc_id = module.network.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}