terraform {
  required_version = ">= 1.6"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.59"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

data "terraform_remote_state" "cluster" {
  backend = "local"

  config = {
    path = "${path.module}/../cluster/terraform.tfstate"
  }
}

module "workers" {
  source = "../../../modules/hetzner/workers"

  name_prefix  = var.name_prefix
  worker_count = var.worker_count
  server_type  = var.worker_type
  location     = var.location
  ssh_key_name = var.ssh_key_name
  server_ip    = data.terraform_remote_state.cluster.outputs.server_ip

  cloud_init = templatefile("${path.module}/templates/cloud-init-worker.yaml.tftpl", {
    server_ip = data.terraform_remote_state.cluster.outputs.server_ip
    k3s_token = data.terraform_remote_state.cluster.outputs.k3s_token
  })

  labels = {
    environment = "dev"
    managed_by  = "opentofu"
    role        = "worker"
  }
}
