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
  network_id     = data.terraform_remote_state.persistent.outputs.network_id

  cloud_init = templatefile("${path.module}/templates/cloud-init.yaml.tftpl", {
    floating_ip       = data.terraform_remote_state.persistent.outputs.floating_ip_address
    letsencrypt_email = var.letsencrypt_email
    argocd_domain     = var.argocd_domain
    k3s_token         = data.terraform_remote_state.persistent.outputs.k3s_token
    kolkhis_google_client_id     = var.kolkhis_google_client_id
    kolkhis_google_client_secret = var.kolkhis_google_client_secret
    kolkhis_jwt_secret           = var.kolkhis_jwt_secret
    s3_access_key                = data.terraform_remote_state.persistent.outputs.s3_access_key
    s3_secret_key                = data.terraform_remote_state.persistent.outputs.s3_secret_key
    s3_endpoint                  = data.terraform_remote_state.persistent.outputs.s3_endpoint
    s3_bucket_name               = data.terraform_remote_state.persistent.outputs.s3_bucket_name
    hcloud_token                 = var.hcloud_token
    worker_auth_token            = var.worker_auth_token
    worker_snapshot_id           = var.worker_snapshot_id
    worker_network_id            = data.terraform_remote_state.persistent.outputs.network_id
    s3_results_bucket            = data.terraform_remote_state.persistent.outputs.s3_results_bucket_name
    s3_region                    = var.location
  })

  labels = {
    environment = "dev"
    managed_by  = "opentofu"
  }
}
