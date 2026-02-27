variable "server_name" {
  description = "Name of the server"
  type        = string
}

variable "server_type" {
  description = "Hetzner server type (e.g. cpx42, cpx52)"
  type        = string
}

variable "location" {
  description = "Hetzner datacenter location"
  type        = string
  default     = "fsn1"
}

variable "image" {
  description = "OS image for the server"
  type        = string
  default     = "ubuntu-24.04"
}

variable "ssh_key_name" {
  description = "Name of the pre-existing SSH key in Hetzner"
  type        = string
}

variable "cloud_init" {
  description = "Rendered cloud-init user data"
  type        = string
}

variable "floating_ip_id" {
  description = "ID of the persistent floating IP to attach"
  type        = number
}

variable "volume_id" {
  description = "ID of the persistent volume to attach"
  type        = number
}

variable "network_id" {
  description = "ID of the private network to attach to"
  type        = number
}

variable "labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default     = {}
}
