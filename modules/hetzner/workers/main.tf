terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.59"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

data "hcloud_ssh_key" "main" {
  name = var.ssh_key_name
}

resource "hcloud_server" "workers" {
  count       = var.worker_count
  name        = "${var.name_prefix}-worker-${count.index + 1}"
  server_type = var.server_type
  image       = var.image
  location    = var.location
  ssh_keys    = [data.hcloud_ssh_key.main.id]
  user_data   = var.cloud_init
  labels      = var.labels
}

resource "null_resource" "node_cleanup" {
  count = var.worker_count

  triggers = {
    node_name = "${var.name_prefix}-worker-${count.index + 1}"
    server_ip = var.server_ip
  }

  provisioner "local-exec" {
    when    = destroy
    command = "ssh -o StrictHostKeyChecking=no root@${self.triggers.server_ip} 'kubectl drain ${self.triggers.node_name} --ignore-daemonsets --delete-emptydir-data --timeout=30s 2>/dev/null; kubectl delete node ${self.triggers.node_name}'"
  }
}
