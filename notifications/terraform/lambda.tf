resource "aws_lambda_function" "send_notification_register" {
  function_name = "send-notification-register"
  handler       = "handler.handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "build/send_notification_register.zip"

  environment {
    variables = {
      TEMPLATE_BUCKET = aws_s3_bucket.templates.bucket
    }
  }
}

resource "aws_lambda_function" "send_notification_login" {
  function_name = "send-notification-login"
  handler       = "handler.handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "build/send_notification_login.zip"

  environment {
    variables = {
      TEMPLATE_BUCKET = aws_s3_bucket.templates.bucket
    }
  }
}

# Conectar las lambdas a la cola SQS
resource "aws_lambda_event_source_mapping" "register_sqs_trigger" {
  event_source_arn = aws_sqs_queue.notification_email.arn
  function_name    = aws_lambda_function.send_notification_register.arn
}

resource "aws_lambda_event_source_mapping" "login_sqs_trigger" {
  event_source_arn = aws_sqs_queue.notification_email.arn
  function_name    = aws_lambda_function.send_notification_login.arn
}
