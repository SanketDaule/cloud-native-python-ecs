module "network" {
  source = "./modules/vpc"

  vpc_cidr_block       = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  region               = var.region

  public_subnet_map    = var.public_subnet_map
  private_subnet_map   = var.private_subnet_map

  tags = {
    Environment = "dev"
    Project     = "ecs-app"
  }
}
