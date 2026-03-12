resource "aws_sqs_queue" "notification_dlq" {
  name = "notification-email-error-sqs"
}

resource "aws_sqs_queue" "notification_queue" {
  name = "notification-email-sqs"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.notification_dlq.arn
    maxReceiveCount     = 3
  })
}