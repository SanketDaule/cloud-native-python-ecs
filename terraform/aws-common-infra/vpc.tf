module "network" {
  source = "../modules/vpc"

  name_prefix           = var.project
  vpc_cidr_block        = var.vpc_cidr_block
  enable_dns_support    = var.enable_dns_support
  enable_dns_hostnames  = var.enable_dns_hostnames

  public_subnet_map     = var.public_subnet_map
  private_subnet_map    = var.private_subnet_map

  create_gateway_endpoints         = var.create_gateway_endpoints
  enable_s3_gateway_endpoint       = var.enable_s3_gateway_endpoint
  enable_dynamodb_gateway_endpoint = var.enable_dynamodb_gateway_endpoint

  create_interface_endpoints       = var.create_interface_endpoints
  enable_ecr_interface_endpoints   = var.enable_ecr_interface_endpoints
  #enable_logs_interface_endpoint    = var.enable_logs_interface_endpoint

  endpoint_allowed_sg_id = var.endpoint_allowed_sg_id
  endpoint_allowed_cidrs = var.endpoint_allowed_cidrs

  tags = merge(
    {
      Environment = "dev"
      Project     = "ecs-app"
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}


output "vpc_id"                { value = module.network.vpc_id }
output "public_subnet_ids"     { value = module.network.public_subnet_ids }
output "private_subnet_ids"    { value = module.network.private_subnet_ids }
output "vpce_security_group_id"{ value = module.network.vpce_security_group_id }