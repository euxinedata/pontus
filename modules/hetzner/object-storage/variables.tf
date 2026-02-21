variable "access_key" {
  description = "Hetzner Object Storage access key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "Hetzner Object Storage secret key"
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Hetzner datacenter location (used in S3 endpoint)"
  type        = string
  default     = "nbg1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}
