output "server_id" {
  description = "ID of the created server"
  value       = hcloud_server.main.id
}

output "server_ip" {
  description = "Public IPv4 address of the server"
  value       = hcloud_server.main.ipv4_address
}
