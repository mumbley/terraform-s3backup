resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.s3_bucket_config.name}-${var.deployment_name}"
  tags   = var.s3_bucket_config.tags
}
resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    id     = "backup expiry"
    status = var.s3_bucket_config.enabled == true ? "Enabled" : "Disabled"
    expiration {
      days = var.s3_bucket_config.expiration_days
    }
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = var.s3_bucket_config.acl

}

