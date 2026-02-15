terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.59"
    }
  }
}

resource "hcloud_floating_ip" "main" {
  type          = "ipv4"
  home_location = var.location
  name          = "${var.name_prefix}-fip"
  labels        = var.labels
}

resource "hcloud_volume" "main" {
  name     = "${var.name_prefix}-vol"
  size     = var.volume_size
  location = var.location
  format   = "ext4"
  labels   = var.labels
}
