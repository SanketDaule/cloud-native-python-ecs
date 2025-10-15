variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "enable_dns_hostnames" {
  description = "Whether to enable DNS hostnames in the VPC"
  type        = bool
}

variable "enable_dns_support" {
  description = "Whether to enable DNS support in the VPC"
  type        = bool
}

variable "tags" {
  description = "Tags to assign to the VPC"
  type        = map(string)
}

variable "private_subnet_map" {
  description = "Map of private subnet configurations"
  type        = map(any)
}

variable "private_subnets" {
  description = "Map of private subnets in the VPC"
  type        = map(string)
}

variable "azs" {
  description = "Availability zones for the VPC"
  type        = list(string)
}

variable "all_private_subnet_ids" {
  description = "List of all private subnet IDs"
  type        = list(string)
}

variable "private_subnet_tags" {
  description = "Tags to assign to private subnets"
  type        = map(string)
}

variable "private_subnet_list" {
  description = "List of private subnet objects"
  type        = list(object({
    cidr_block        = string
    availability_zone = string
    tags              = map(string)
  }))
}