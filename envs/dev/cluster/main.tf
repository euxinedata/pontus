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

data "terraform_remote_state" "persistent" {
  backend = "local"

  config = {
    path = "${path.module}/../persistent/terraform.tfstate"
  }
}

module "cluster" {
  source = "../../../modules/hetzner/cluster"

  server_name  = var.server_name
  server_type  = var.server_type
  location     = var.location
  ssh_key_name = var.ssh_key_name

  floating_ip_id = data.terraform_remote_state.persistent.outputs.floating_ip_id
  volume_id      = data.terraform_remote_state.persistent.outputs.volume_id

  cloud_init = templatefile("${path.module}/templates/cloud-init.yaml.tftpl", {
    floating_ip       = data.terraform_remote_state.persistent.outputs.floating_ip_address
    letsencrypt_email = var.letsencrypt_email
    argocd_domain     = var.argocd_domain
    k3s_token         = random_password.k3s_token.result
  })

  labels = {
    environment = "dev"
    managed_by  = "opentofu"
  }
}
