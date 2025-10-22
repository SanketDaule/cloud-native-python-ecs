variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "environment" {
  type = string
}

variable "project" {
  type    = string
  default = "cloud-native-python-ecs"
}

variable "vpc_cidr_block" {
  type    = string
}

variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}

variable "public_subnet_map" {
  description = "Map of public subnets"
  type = map(object({
    cidr_block = string
    az         = string
    tags       = map(string)
  }))
}

variable "private_subnet_map" {
  description = "Map of private subnets"
  type = map(object({
    cidr_block = string
    az         = string
    tags       = map(string)
  }))
}


# Endpoint toggles exposed at infra layer (optional)
variable "create_gateway_endpoints" {
  type    = bool
}

variable "enable_s3_gateway_endpoint" {
  type    = bool
}

variable "enable_dynamodb_gateway_endpoint" {
  type    = bool
}

variable "create_interface_endpoints" {
  type    = bool
}

variable "enable_ecr_interface_endpoints" {
  type    = bool
}

variable "enable_logs_interface_endpoint" {
  type    = bool
}


# If you already have the ECS Task SG, pass it to harden the endpoints
variable "endpoint_allowed_sg_id" {
  type    = string
  default = null
}

variable "endpoint_allowed_cidrs" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
