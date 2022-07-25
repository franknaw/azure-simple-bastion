output "azurerm_network_security_rule" {
  description = "Virtual network data object."
  value       = azurerm_network_security_rule.bastion_sr
}

output "bastion_public_ip" {
  description = "Virtual network data object."
  value       = azurerm_public_ip.bastion.ip_address
}

output "bastion_private_ip" {
  description = "Virtual network data object."
  value       = azurerm_linux_virtual_machine.bastion.*.private_ip_address
}
