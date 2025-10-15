output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "The VPC ARN"
  value       = aws_vpc.this.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}


output "private_route_table" {
  description = "ID of the private route table (deprecated: use private_route_table_id instead)"
  value       = aws_route_table.private_route_table[*].id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private_route_table.id
}