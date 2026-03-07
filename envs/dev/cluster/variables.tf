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

variable "gitea_admin_user" {
  description = "Gitea admin username"
  type        = string
  default     = "kolkhis-admin"
}

variable "gitea_admin_password" {
  description = "Gitea admin password"
  type        = string
  sensitive   = true
}

variable "gitea_admin_email" {
  description = "Gitea admin email"
  type        = string
  default     = "admin@kolkhis.local"
}

variable "shell_ssh_private_key" {
  description = "SSH private key (ed25519) for backend to connect to shell pod"
  type        = string
  sensitive   = true
}

variable "shell_ssh_public_key" {
  description = "SSH public key (ed25519) for shell pod authorized_keys"
  type        = string
}

variable "dagster_pg_username" {
  description = "PostgreSQL username for Dagster"
  type        = string
  default     = "kolkhis"
}

variable "dagster_pg_password" {
  description = "PostgreSQL password for Dagster"
  type        = string
  sensitive   = true
}

variable "dagster_pg_host" {
  description = "PostgreSQL host for Dagster"
  type        = string
  default     = "postgres"
}

variable "dagster_pg_db" {
  description = "PostgreSQL database name for Dagster"
  type        = string
  default     = "dagster"
}

variable "dagster_image" {
  description = "Docker image for Dagster"
  type        = string
  default     = "ghcr.io/euxinedata/dagster:latest"
}


