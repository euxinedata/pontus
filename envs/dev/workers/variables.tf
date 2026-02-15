variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "name_prefix" {
  description = "Prefix for worker server names"
  type        = string
  default     = "pontus-dev"
}

variable "worker_count" {
  description = "Number of worker nodes to create"
  type        = number
  default     = 1
}

variable "worker_type" {
  description = "Hetzner server type for workers (e.g. cpx21, cpx42)"
  type        = string
  default     = "cpx21"
}

variable "location" {
  description = "Hetzner datacenter location"
  type        = string
  default     = "fsn1"
}

variable "ssh_key_name" {
  description = "Name of the pre-existing SSH key in Hetzner"
  type        = string
}
