vpc_cidr_block = "10.0.0.0/16"
public_subnet_map = {
  "public-a" = {
    cidr_block = "10.0.1.0/24"
    az         = "ap-south-1a"
    tags = {
      Name = "ecs-app-public-subnet-a"
      Type = "public"
    }
  }
  "public-b" = {
    cidr_block = "10.0.2.0/24"
    az         = "ap-south-1b"
    tags = {
      Name = "ecs-app-public-subnet-b"
      Type = "public"
    }
  }
}

private_subnet_map = {
  "private-a" = {
    cidr_block = "10.0.3.0/24"
    az         = "ap-south-1a"
    tags = {
      Name = "ecs-app-private-subnet-a"
      Type = "private"
    }
  }
  "private-b" = {
    cidr_block = "10.0.4.0/24"
    az         = "ap-south-1b"
    tags = {
      Name = "ecs-app-private-subnet-b"
      Type = "private"
    }
  }
}

create_gateway_endpoints         = true
enable_s3_gateway_endpoint       = true
enable_dynamodb_gateway_endpoint = true
create_interface_endpoints       = true
enable_ecr_interface_endpoints   = true
enable_logs_interface_endpoint   = true

# Until ECS Task SG exists, allow within VPC
endpoint_allowed_sg_id = null
endpoint_allowed_cidrs = ["10.0.0.0/16"]

tags = {
  Owner = "platform"
}
