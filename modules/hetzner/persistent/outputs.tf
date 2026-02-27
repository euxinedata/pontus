output "floating_ip_id" {
  description = "ID of the floating IP"
  value       = hcloud_floating_ip.main.id
}

output "floating_ip_address" {
  description = "Floating IP address (point DNS here)"
  value       = hcloud_floating_ip.main.ip_address
}

output "volume_id" {
  description = "ID of the persistent volume"
  value       = hcloud_volume.main.id
}

output "volume_linux_device" {
  description = "Linux device path of the volume"
  value       = hcloud_volume.main.linux_device
}

output "network_id" {
  description = "ID of the private network"
  value       = hcloud_network.main.id
}

output "cluster_subnet_id" {
  description = "ID of the cluster subnet"
  value       = hcloud_network_subnet.cluster.id
}

output "workers_subnet_id" {
  description = "ID of the workers subnet"
  value       = hcloud_network_subnet.workers.id
}
