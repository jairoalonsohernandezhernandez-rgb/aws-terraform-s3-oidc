resource "aws_s3_bucket" "bucket_principal" {
  bucket = var.bucket_name
  force_destroy = var.force_destroy

  tags = {
    Environment = var.environment
    Application = var.application
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = aws_s3_bucket.bucket_principal.id

    rule {
      id = "politica_retencion_datos"
      status = "Enabled"

      filter {}

      transition {
        days = 30
        storage_class = "STANDARD_IA"
      }

      transition {
        days = 90
        storage_class = "DEEP_ARCHIVE"
      }

      expiration {
        days = 365
      }
    }
}