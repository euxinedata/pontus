variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "pontus-dev"
}

variable "location" {
  description = "Hetzner datacenter location"
  type        = string
  default     = "fsn1"
}

variable "volume_size" {
  description = "Size of the persistent volume in GB"
  type        = number
  default     = 50
}

variable "s3_access_key" {
  description = "Hetzner Object Storage access key"
  type        = string
  sensitive   = true
}

variable "s3_secret_key" {
  description = "Hetzner Object Storage secret key"
  type        = string
  sensitive   = true
}
