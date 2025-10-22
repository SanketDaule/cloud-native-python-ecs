data "aws_region" "current" {}

resource "aws_vpc" "ecs_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = merge(var.tags, { Name = "${var.name_prefix}-vpc" })
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags   = merge(var.tags, { Name = "${var.name_prefix}-igw" })
}

#--------public and private subnets---------------
resource "aws_subnet" "public" {
  for_each = var.public_subnet_map

  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = true
  tags = merge(var.tags, each.value.tags, {
      Name = coalesce(lookup(each.value.tags, "Name", null), "${var.name_prefix}-public-${each.key}")
      Tier = "public"
    })
}

resource "aws_subnet" "private" {
  for_each = var.private_subnet_map

  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = merge(var.tags, each.value.tags, {
      Name = coalesce(lookup(each.value.tags, "Name", null), "${var.name_prefix}-private-${each.key}")
      Tier = "private"
    })
}

# ---------------- Routing ----------------
# Public RT with default route to Internet via IGW
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags   = merge(var.tags, { Name = "${var.name_prefix}-public-rt" })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gw.id
}

resource "aws_route_table_association" "public_rt_association" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

# Single private RT
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags   = merge(var.tags, { Name = "${var.name_prefix}-private-rt" })
}

resource "aws_route_table_association" "private_rt_association" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}

#Security Group for Interface Endpoints 
resource "aws_security_group" "vpc_endpoint" {
  name        = "${var.name_prefix}-vpc-endpoint-sg"
  description = "Allow ECS tasks to reach VPC Interface Endpoints (443)"
  vpc_id      = aws_vpc.this.id
  tags        = merge(var.tags, { Name = "${var.name_prefix}-vpc-endpoint-sg" })

  # Egress: allow responses
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Ingress 443 from ECS Task SG (preferred)
resource "aws_security_group_rule" "vpce_ingress_from_tasks" {
  count                    = var.endpoint_allowed_sg_id != null ? 1 : 0
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vpc_endpoint.id
  source_security_group_id = var.endpoint_allowed_sg_id
}

#Ingress 443 from cidrs
#Fallback if task sg is yet to be created
locals {
  endpoint_cidrs = length(var.endpoint_allowed_cidrs) > 0 ? var.endpoint_allowed_cidrs : [aws_vpc.this.cidr_block]
}

resource "aws_security_group_rule" "vpce_ingress_from_cidrs" {
  count             = var.endpoint_allowed_sg_id == null ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.vpc_endpoint.id
  cidr_blocks       = local.endpoint_cidrs
}

#Gateway Endpoints (S3, DynamoDB)
resource "aws_vpc_endpoint" "s3" {
  count             = var.create_gateway_endpoints && var.enable_s3_gateway_endpoint ? 1 : 0
  vpc_id            = aws_vpc.ecs_vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]
  tags              = merge(var.tags, { Name = "${var.name_prefix}-s3-gw-endpoint" })
}

resource "aws_vpc_endpoint" "dynamodb" {
  count             = var.create_gateway_endpoints && var.enable_dynamodb_gateway_endpoint ? 1 : 0
  vpc_id            = aws_vpc.ecs_vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]
  tags              = merge(var.tags, { Name = "${var.name_prefix}-dynamodb-gw-endpoint" })
}


#Interface Endpoints (ECR API, ECR DKR, Logs)
locals {
  private_subnet_ids = [for s in aws_subnet.private : s.id]
}

# ECR API
resource "aws_vpc_endpoint" "ecr_api" {
  count               = var.create_interface_endpoints && var.enable_ecr_interface_endpoints ? 1 : 0
  vpc_id              = aws_vpc.ecs_vpc.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.private_subnet_ids
  security_group_ids  = [aws_security_group.vpce.id]
  tags                = merge(var.tags, { Name = "${var.name_prefix}-ecr-api-if-endpoint" })
}

# ECR DKR (registry)
resource "aws_vpc_endpoint" "ecr_dkr" {
  count               = var.create_interface_endpoints && var.enable_ecr_interface_endpoints ? 1 : 0
  vpc_id              = aws_vpc.ecs_vpc.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.private_subnet_ids
  security_group_ids  = [aws_security_group.vpce.id]
  tags                = merge(var.tags, { Name = "${var.name_prefix}-ecr-dkr-if-endpoint" })
}

# CloudWatch Logs (for awslogs driver)
# resource "aws_vpc_endpoint" "logs" {
#   count               = var.create_interface_endpoints && var.enable_logs_interface_endpoint ? 1 : 0
#   vpc_id              = aws_vpc.ecs_vpc.id
#   service_name        = "com.amazonaws.${data.aws_region.current.name}.logs"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true
#   subnet_ids          = local.private_subnet_ids
#   security_group_ids  = [aws_security_group.vpce.id]
#   tags                = merge(var.tags, { Name = "${var.name_prefix}-logs-if-endpoint" })
# }
