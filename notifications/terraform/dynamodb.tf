resource "aws_dynamodb_table" "notification_table" {
  name           = "notification-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "uuid"
  range_key      = "createdAt"

  attribute {
    name = "uuid"
    type = "S"
  }

  attribute {
    name = "createdAt"
    type = "S"
  }

  tags = {
    Service = "Notification"
    Env     = "dev"
  }
}

resource "aws_dynamodb_table" "notification_error_table" {
  name           = "notification-error-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "uuid"
  range_key      = "createdAt"

  attribute {
    name = "uuid"
    type = "S"
  }

  attribute {
    name = "createdAt"
    type = "S"
  }

  tags = {
    Service = "Notification"
    Env     = "dev"
  }
}
