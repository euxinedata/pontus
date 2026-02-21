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
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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

module "object_storage" {
  source      = "../../../modules/hetzner/object-storage"
  bucket_name = "${var.name_prefix}-iceberg"
  location    = var.location
  access_key  = var.s3_access_key
  secret_key  = var.s3_secret_key
}
