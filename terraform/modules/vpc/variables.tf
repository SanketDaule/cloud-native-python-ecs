variable "name_prefix" {
  description = "Name prefix for VPC resources"
  type        = string
  default     = "cloud-native-ecs-app"
}

variable "vpc_cidr_block" {
  type        = string
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "public_subnet_map" {
  type = map(object({
    cidr_block = string
    az         = string
    tags       = map(string)
  }))
}

variable "private_subnet_map" {
  type = map(object({
    cidr_block = string
    az         = string
    tags       = map(string)
  }))
}

#Endpoints toggles
variable "create_gateway_endpoints" {
  description = "Create Gateway endpoints (S3 + DynamoDB)"
  type        = bool
  default     = true
}

variable "enable_s3_gateway_endpoint" {
  description = "Create S3 Gateway endpoint (required for ECR image layers)"
  type        = bool
  default     = true
}

variable "enable_dynamodb_gateway_endpoint" {
  description = "Create DynamoDB Gateway endpoint"
  type        = bool
  default     = true
}

variable "create_interface_endpoints" {
  description = "Create Interface endpoints (ECR API, ECR DKR, Logs)"
  type        = bool
  default     = true
}

variable "enable_ecr_interface_endpoints" {
  description = "Create ECR API + ECR DKR interface endpoints"
  type        = bool
  default     = true
}

# variable "enable_logs_interface_endpoint" {
#   description = "Create CloudWatch Logs interface endpoint"
#   type        = bool
#   default     = true
# }

# Restrict who can talk to the Interface endpoint ENIs (port 443)
variable "endpoint_allowed_sg_id" {
  description = "(Preferred) Security Group ID of ECS tasks allowed to reach the interface endpoints"
  type        = string
  default     = null
}

variable "endpoint_allowed_cidrs" {
  description = "Fallback list of CIDRs allowed to reach the interface endpoints on 443 (used when endpoint_allowed_sg_id is null)"
  type        = list(string)
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}