terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.59"
    }
  }
}

data "hcloud_ssh_key" "main" {
  name = var.ssh_key_name
}

resource "hcloud_server" "main" {
  name        = var.server_name
  server_type = var.server_type
  image       = var.image
  location    = var.location
  ssh_keys    = [data.hcloud_ssh_key.main.id]
  user_data   = var.cloud_init
  labels      = var.labels
}

resource "hcloud_floating_ip_assignment" "main" {
  floating_ip_id = var.floating_ip_id
  server_id      = hcloud_server.main.id
}

resource "hcloud_volume_attachment" "main" {
  volume_id = var.volume_id
  server_id = hcloud_server.main.id
  automount = false
}

resource "hcloud_server_network" "main" {
  server_id  = hcloud_server.main.id
  network_id = var.network_id
}
