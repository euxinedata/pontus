output "server_ip" {
  description = "Public IPv4 address of the server"
  value       = module.cluster.server_ip
}

output "floating_ip_address" {
  description = "Floating IP address (from persistent layer)"
  value       = data.terraform_remote_state.persistent.outputs.floating_ip_address
}
