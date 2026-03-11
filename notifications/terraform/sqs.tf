resource "aws_sqs_queue" "notification_email" {
  name = "notification-email-sqs"
}

resource "aws_sqs_queue" "notification_email_error" {
  name = "notification-email-error-sqs"
}
