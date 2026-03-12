data "archive_file" "send_notifications_zip" {

  type = "zip"

  source_dir = "${path.module}/../src/send_notifications"

  output_path = "${path.module}/send_notifications.zip"

}

resource "aws_lambda_function" "send_notifications" {

  function_name = "send-notifications-lambda"

  filename = data.archive_file.send_notifications_zip.output_path

  source_code_hash = data.archive_file.send_notifications_zip.output_base64sha256

  role = aws_iam_role.lambda_role.arn

  handler = "lambda_function.lambda_handler"

  runtime = "python3.12"

  environment {
    variables = {
      TABLE_NAME      = aws_dynamodb_table.notification_table.name
      TEMPLATE_BUCKET = aws_s3_bucket.notification_templates.bucket
    }
  }
}

resource "aws_lambda_event_source_mapping" "notification_trigger" {

  event_source_arn = aws_sqs_queue.notification_queue.arn

  function_name = aws_lambda_function.send_notifications.arn

  batch_size = 10
}