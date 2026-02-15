variable "name_prefix" {
  description = "Prefix for worker server names"
  type        = string
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 1
}

variable "server_type" {
  description = "Hetzner server type (e.g. cpx21, cpx42)"
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

variable "server_ip" {
  description = "IP of the k3s server node (for node cleanup on destroy)"
  type        = string
}

variable "labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default     = {}
}
