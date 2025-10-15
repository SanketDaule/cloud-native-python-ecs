resource "aws_vpc" "ecs_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags                 = var.tags  # Tags from root module
}

resource "aws_subnet" "private" {
  for_each = var.private_subnet_map

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags              = each.value.tags  # Tags from the subnet map
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.this.id
  tags   = var.tags  # Tags from root module
}

resource "aws_route_table_association" "private_route_table_association" {
  for_each = { for index, subnet_id in var.all_private_subnet_ids : index => subnet_id }

  subnet_id      = each.value
  route_table_id = aws_route_table.private_route_table.id
}