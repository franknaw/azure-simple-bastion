
# locals {
#   hosts       = toset(["bastion", "private"])
#   access_list = {
#     my_ip = "${chomp(data.http.my_ip.body)}/32"
#   }
# }

# resource "random_string" "random" {
#   length  = 12
#   upper   = false
#   special = false
# }

# resource "tls_private_key" "ssh_keys" {
#   for_each    = local.hosts
#   algorithm   = "RSA"
# }

# resource "local_file" "pem_files" {
#     for_each        = local.hosts
#     content         = tls_private_key.ssh_keys[each.value].private_key_pem
#     filename        = "${path.module}/${each.value}.pem"
#     file_permission = "0600" 
# }

# data "http" "my_ip" {
#   url = "http://ipv4.icanhazip.com"
# }

resource "azurerm_public_ip" "bastion" {
  name                = "${var.names.product_group}-bastion-public"
  resource_group_name = var.resource_group_name
  location            = var.location

  allocation_method   = "Static"
  sku                 = "Basic"

  tags                = var.tags
}

resource "azurerm_network_interface" "bastion" {
  name                = "${var.names.product_group}-bastion"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "bastion"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion.id
  }

  tags                = var.tags
}

resource "azurerm_network_security_rule" "bastion_sr" {
  name                        = "bastion-sr"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = values(var.source_address_prefixes)
  destination_address_prefix  = azurerm_network_interface.bastion.private_ip_address
  #destination_address_prefix = var.destination_address_prefix
  
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
  depends_on                  = [azurerm_network_security_group.nsg]
}


resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {

  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_group" "nsg" {

  name                = "${var.names.resource_group_type}-${var.names.product_name}-security-group"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = merge(var.tags, {foo = "foo"})
}

resource "azurerm_linux_virtual_machine" "bastion" {
  name                = "${var.names.product_name}-bastion"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2s"
  disable_password_authentication = true
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.bastion.id,
  ]

  admin_ssh_key {
    username   = var.username
    public_key = var.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}