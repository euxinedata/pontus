terraform {
  required_version = ">= 1.6"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.59"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "random_password" "k3s_token" {
  length  = 48
  special = false
}

module "persistent" {
  source = "../../../modules/hetzner/persistent"

  name_prefix = var.name_prefix
  location    = var.location
  volume_size = var.volume_size

  labels = {
    environment = "dev"
    managed_by  = "opentofu"
  }
}
