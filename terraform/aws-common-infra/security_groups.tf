resource "aws_security_group" "ecs_service_sg" {
  name   = "${var.name_prefix}-${var.environment}-cluster-sg"
  vpc_id = module.network.vpc_id

  # inbound traffic from the ALB only
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_app_alb_sg.id] # only allow traffic from ALB security group
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

resource "aws_security_group" "lambda_sg" {
  name        = "${var.name_prefix}-${var.environment}-lambda-sg"
  description = "Security group for Lambda function to access DynamoDB and VPC endpoints"
  vpc_id      = module.network.vpc_id

  # No ingress (Lambda doesn't receive inbound traffic)

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block] # restricted to VPC network
  }

  tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}
