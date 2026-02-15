output "worker_ips" {
  description = "Public IPv4 addresses of the worker nodes"
  value       = module.workers.worker_ips
}
