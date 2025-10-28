module "aws-common-infra" {
  source                           = "../../aws-common-infra"
  environment                      = var.environment
  name_prefix                      = var.name_prefix
  vpc_cidr_block                   = var.vpc_cidr_block
  public_subnet_map                = var.public_subnet_map
  private_subnet_map               = var.private_subnet_map
  endpoint_allowed_cidrs           = var.endpoint_allowed_cidrs
  create_gateway_endpoints         = true
  enable_logs_interface_endpoint   = true
  enable_s3_gateway_endpoint       = true
  enable_dynamodb_gateway_endpoint = true
  create_interface_endpoints       = true
  enable_ecr_interface_endpoints   = true

  tags                             = var.tags
}