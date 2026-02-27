output "floating_ip_id" {
  description = "ID of the floating IP (used by cluster layer)"
  value       = module.persistent.floating_ip_id
}

output "floating_ip_address" {
  description = "Floating IP address (point DNS here)"
  value       = module.persistent.floating_ip_address
}

output "volume_id" {
  description = "ID of the persistent volume (used by cluster layer)"
  value       = module.persistent.volume_id
}

output "volume_linux_device" {
  description = "Linux device path of the volume"
  value       = module.persistent.volume_linux_device
}

output "k3s_token" {
  description = "k3s cluster token (stable across cluster rebuilds)"
  value       = random_password.k3s_token.result
  sensitive   = true
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for Iceberg tables"
  value       = module.object_storage.bucket_name
}

output "s3_endpoint" {
  description = "S3 endpoint URL for Hetzner Object Storage"
  value       = module.object_storage.s3_endpoint
}

output "s3_access_key" {
  description = "S3 access key for Hetzner Object Storage"
  value       = var.s3_access_key
  sensitive   = true
}

output "s3_secret_key" {
  description = "S3 secret key for Hetzner Object Storage"
  value       = var.s3_secret_key
  sensitive   = true
}

output "network_id" {
  description = "ID of the private network"
  value       = module.persistent.network_id
}

output "s3_results_bucket_name" {
  description = "Name of the S3 bucket for query results (uses iceberg bucket with results/ prefix)"
  value       = module.object_storage.bucket_name
}
