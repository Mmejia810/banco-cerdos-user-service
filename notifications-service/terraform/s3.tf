resource "random_id" "rand" {
  byte_length = 4
}

resource "aws_s3_bucket" "notification_templates" {
  bucket = "templates-email-notification-${random_id.rand.hex}"
}