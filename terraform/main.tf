# terraform/main.tf

provider "aws" {
  region = "us-east-1"
}


# DynamoDB - Tabla Usuarios

resource "aws_dynamodb_table" "users_table" {
  name         = "users-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "uuid"
  range_key    = "documento"

  attribute {
    name = "uuid"
    type = "S"
  }

  attribute {
    name = "documento"
    type = "S"
  }
}


# Secrets Manager - JWT Key

resource "aws_secretsmanager_secret" "jwt_secret" {
  name = "banco-cerdos-jwt-key"
}

resource "aws_secretsmanager_secret_version" "jwt_secret_value" {
  secret_id     = aws_secretsmanager_secret.jwt_secret.id
  secret_string = "CAMBIA_ESTA_CLAVE_EN_PRODUCCION"
}


# SQS - Cola tarjetas

resource "aws_sqs_queue" "card_request_queue" {
  name = "create-request-card-sqs"
}


# IAM Role para Lambda

resource "aws_iam_role" "lambda_role" {
  name = "user_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Logs
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# DynamoDB Access
resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# SQS Access
resource "aws_iam_role_policy_attachment" "lambda_sqs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_lambda_function" "register_lambda" {
  filename      = "register.zip"
  function_name = "register-user-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "register.lambda_handler"
  runtime       = "python3.9"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.users_table.name
      # Corregido: Ahora coincide con el nombre del recurso definido arriba
      QUEUE_URL  = aws_sqs_queue.card_request_queue.id 
    }
  }
}
# Permiso para que API Gateway pueda ejecutar la Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.register_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # El source_arn es opcional pero recomendado por seguridad
  # source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
