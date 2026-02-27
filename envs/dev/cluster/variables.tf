variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "server_name" {
  description = "Name of the server"
  type        = string
  default     = "pontus-dev-01"
}

variable "server_type" {
  description = "Hetzner server type (e.g. cpx42, cpx52)"
  type        = string
  default     = "cpx42"
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

variable "letsencrypt_email" {
  description = "Email address for Let's Encrypt certificate notifications"
  type        = string
}

variable "argocd_domain" {
  description = "Domain name for ArgoCD web UI"
  type        = string
}

variable "kolkhis_google_client_id" {
  description = "Google OAuth client ID for Kolkhis"
  type        = string
  sensitive   = true
}

variable "kolkhis_google_client_secret" {
  description = "Google OAuth client secret for Kolkhis"
  type        = string
  sensitive   = true
}

variable "kolkhis_jwt_secret" {
  description = "JWT signing secret for Kolkhis"
  type        = string
  sensitive   = true
}

variable "worker_auth_token" {
  description = "Auth token for worker VMs"
  type        = string
  sensitive   = true
  default     = ""
}

variable "worker_snapshot_id" {
  description = "Hetzner snapshot ID for worker VM image"
  type        = string
  default     = ""
}

