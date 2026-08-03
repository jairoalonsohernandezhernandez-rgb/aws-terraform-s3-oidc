output "bucket_arn" {
  description = "El ARN del bucket de S3"
  value = aws_s3_bucket.this.arn
}