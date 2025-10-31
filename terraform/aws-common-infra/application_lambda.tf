data "archive_file" "ecs_app_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../../backend/main.py"
  output_path = "/tmp/ecs_lambda_code.zip"
}

resource "aws_lambda_function" "ecs_app_lambda" {
  function_name    = "${var.name_prefix}-${var.environment}-lambda-function"
  role             = aws_iam_role.ecs_app_lambda_iam_role.arn
  handler          = "aws_int_lambda_code.lambda_handler"
  runtime          = "python3.12"
  layers           = [aws_lambda_layer_version.ecs_app_lambda_layer.arn]
  timeout          = 30
  memory_size      = 128
  filename         = data.archive_file.ecs_app_lambda_zip.output_path
  source_code_hash = data.archive_file.ecs_app_lambda_zip.output_base64sha512

  environment {
    variables = {
      AWS_REGION     = var.region
      DYNAMODB_TABLE = aws_dynamodb_table.ecs_data_store.name
    }
  }

}

resource "aws_iam_role" "ecs_app_lambda_iam_role" {
  name               = "${var.name_prefix}-${var.environment}-lambda-iam-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_lambda_layer_version" "ecs_app_lambda_layer" {
  filename         = "../build/lambda_layer.zip"
  layer_name       = "${var.name_prefix}-lambda-layer"
  source_code_hash = filebase64sha256("../build/lambda_layer.zip")

  compatible_runtimes = ["python3.12"]
}