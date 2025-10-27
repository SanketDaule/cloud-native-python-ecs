region = "ap-south-1"

vpc_cidr_block       = "10.1.0.0/16"
enable_dns_support   = true
enable_dns_hostnames = true

public_subnet_map = {
  public-a = { cidr_block = "10.1.1.0/24", az = "ap-south-1a", tags = { Name = "ecs-app-public-a", Type = "public" } }
  public-b = { cidr_block = "10.1.2.0/24", az = "ap-south-1b", tags = { Name = "ecs-app-public-b", Type = "public" } }
}

private_subnet_map = {
  private-a = { cidr_block = "10.1.11.0/24", az = "ap-south-1a", tags = { Name = "ecs-app-private-a", Type = "private" } }
  private-b = { cidr_block = "10.1.12.0/24", az = "ap-south-1b", tags = { Name = "ecs-app-private-b", Type = "private" } }
}

create_gateway_endpoints         = true
enable_s3_gateway_endpoint       = true
enable_dynamodb_gateway_endpoint = true
create_interface_endpoints       = true
enable_ecr_interface_endpoints   = true
enable_logs_interface_endpoint   = true

# In prod, lock endpoints to the ECS task SG once created
endpoint_allowed_sg_id = null # replace with module.ecs.task_sg_id later
endpoint_allowed_cidrs = ["10.1.0.0/16"]

tags = {
  Owner      = "platform"
  CostCenter = "prod-apps"
}