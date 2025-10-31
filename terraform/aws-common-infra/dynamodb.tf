resource "aws_dynamodb_table" "ecs_data_store" {
  name         = "${var.name_prefix}-${var.environment}-data-store"
  billing_mode = "PROVISIONED"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = merge(
    {
      Environment = var.environment
      Project     = "ecs-app"
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}