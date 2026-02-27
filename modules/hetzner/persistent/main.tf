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

resource "hcloud_network" "main" {
  name     = "${var.name_prefix}-net"
  ip_range = "10.0.0.0/16"
  labels   = var.labels
}

resource "hcloud_network_subnet" "cluster" {
  network_id   = hcloud_network.main.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

resource "hcloud_network_subnet" "workers" {
  network_id   = hcloud_network.main.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.2.0/24"
}
