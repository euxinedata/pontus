output "worker_ips" {
  description = "Public IPv4 addresses of the worker nodes"
  value       = hcloud_server.workers[*].ipv4_address
}

output "worker_ids" {
  description = "IDs of the worker servers"
  value       = hcloud_server.workers[*].id
}
