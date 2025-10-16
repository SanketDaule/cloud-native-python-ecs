variable "vpc_cidr_block" {}
variable "enable_dns_support" { default = true }
variable "enable_dns_hostnames" { default = true }
variable "tags" { type = map(string) }

variable "region" {}
variable "endpoint_sg_id" {}

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
