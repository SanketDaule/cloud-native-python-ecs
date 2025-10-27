environment          = "dev"
enable_dns_support   = true
enable_dns_hostnames = true

public_subnet_map = {
  public-a = {
    cidr_block = "10.0.1.0/24"
    az         = "ap-south-1a"
    tags = {
      Name = "ecs-app-public-a"
      Type = "public"
    }
  }
  public-b = {
    cidr_block = "10.0.2.0/24"
    az         = "ap-south-1b"
    tags = {
      Name = "ecs-app-public-b"
      Type = "public"
    }
  }
}

private_subnet_map = {
  private-a = {
    cidr_block = "10.0.3.0/24"
    az         = "ap-south-1a"
    tags = {
      Name = "ecs-app-private-a"
      Type = "private"
    }
  }
  private-b = {
    cidr_block = "10.0.4.0/24"
    az         = "ap-south-1b"
    tags = {
      Name = "ecs-app-private-b"
      Type = "private"
    }
  }
}

# Until ECS Task SG exists, allow within VPC
endpoint_allowed_sg_id = null
