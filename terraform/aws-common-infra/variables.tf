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
  default = "10.0.0.0/16"
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