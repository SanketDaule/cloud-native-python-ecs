resource "aws_vpc" "ecs_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags                 = var.tags
}

resource "aws_internet_gateway" "ecs_vpc" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags   = var.tags
}

# public_subnet Subnets
resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnet_map

  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags                    = each.value.tags
}

resource "aws_route_table" "public_subnet" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags   = var.tags
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public_subnet.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ecs_vpc.id
}

resource "aws_route_table_association" "public_subnet" {
  for_each = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_subnet.id
}

# private_subnet Subnets
resource "aws_subnet" "private_subnet" {
  for_each = var.private_subnet_map

  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = false
  tags                    = each.value.tags
}

resource "aws_route_table" "private_subnet" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags   = var.tags
}

resource "aws_route_table_association" "private_subnet" {
  for_each = aws_subnet.private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_subnet.id
}
