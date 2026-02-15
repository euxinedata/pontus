output "floating_ip_id" {
  description = "ID of the floating IP (used by cluster layer)"
  value       = module.persistent.floating_ip_id
}

output "floating_ip_address" {
  description = "Floating IP address (point DNS here)"
  value       = module.persistent.floating_ip_address
}

output "volume_id" {
  description = "ID of the persistent volume (used by cluster layer)"
  value       = module.persistent.volume_id
}

output "volume_linux_device" {
  description = "Linux device path of the volume"
  value       = module.persistent.volume_linux_device
}
