module "network" {
  source = "./modules/vpc"

  vpc_cidr_block       = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  region               = "ap-south-1"

  tags = {
    Environment = "dev"
    Project     = "ecs-app"
  }

  public_subnet_map = {
    "public-a" = {
      cidr_block = "10.0.1.0/24"
      az         = "ap-south-1a"
      tags       = {
        Name = "public-subnet-a"
        Type = "public"
      }
    }
    "public-b" = {
      cidr_block = "10.0.2.0/24"
      az         = "ap-south-1b"
      tags       = {
        Name = "public-subnet-b"
        Type = "public"
      }
    }
  }

  private_subnet_map = {
    "private-a" = {
      cidr_block = "10.0.3.0/24"
      az         = "ap-south-1a"
      tags       = {
        Name = "private-subnet-a"
        Type = "private"
      }
    }
    "private-b" = {
      cidr_block = "10.0.4.0/24"
      az         = "ap-south-1b"
      tags       = {
        Name = "private-subnet-b"
        Type = "private"
      }
    }
  }
}
