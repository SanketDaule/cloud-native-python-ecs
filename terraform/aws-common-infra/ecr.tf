resource "aws_ecr_repository" "rock_paper_scissors" {
  name                 = "${var.name_prefix}-${var.environment}-ecr"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
  
  tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}