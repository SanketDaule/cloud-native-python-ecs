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
