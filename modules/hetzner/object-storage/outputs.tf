output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket
}

output "s3_endpoint" {
  description = "S3 endpoint URL"
  value       = "https://${var.location}.your-objectstorage.com"
}
