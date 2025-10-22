output "vpc_id" {
  value = aws_vpc.ecs_vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.ecs_vpc.cidr_block
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private : s.id]
}

output "public_route_table_id" {
  value = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  value = aws_route_table.private_rt.id
}

output "vpce_security_group_id" {
  value = aws_security_group.vpc_endpoint.id
}

output "gateway_endpoints" {
  value = {
    s3       = try(aws_vpc_endpoint.s3[0].id, null)
    dynamodb = try(aws_vpc_endpoint.dynamodb[0].id, null)
  }
}

output "interface_endpoints" {
  value = {
    ecr_api = try(aws_vpc_endpoint.ecr_api[0].id, null)
    ecr_dkr = try(aws_vpc_endpoint.ecr_dkr[0].id, null)
    #logs    = try(aws_vpc_endpoint.logs[0].id, null)
  }
}