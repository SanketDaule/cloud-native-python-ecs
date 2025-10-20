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