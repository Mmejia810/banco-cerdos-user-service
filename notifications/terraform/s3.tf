resource "aws_s3_bucket" "templates" {
  bucket = "templates-email-notification-${random_id.suffix.hex}"
}

resource "random_id" "suffix" {
  byte_length = 4
}
