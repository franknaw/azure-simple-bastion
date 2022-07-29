
data "template_file" "linux_script" {
  template = file("${path.module}/scripts/install_runner.sh")
  vars = {
    github_org    = var.github_org_name
    runner_token  = var.github_runner_token
    runner_name   = var.github_runner_name
    runner_group  = "default"
    runner_labels = lower(join(",", var.runner_labels))
  }
}

resource "azurerm_public_ip" "bastion" {
  name                = "${var.names.product_group}-bastion-public"
  resource_group_name = var.resource_group_name
  location            = var.location

  allocation_method = "Static"
  sku               = "Basic"

  tags = var.tags
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

  tags = var.tags
}

resource "azurerm_network_security_rule" "bastion_sr" {
  name                    = "bastion-sr"
  priority                = 101
  direction               = "Inbound"
  access                  = "Allow"
  protocol                = "Tcp"
  source_port_range       = "*"
  destination_port_range  = "22"
  source_address_prefixes = values(var.source_address_prefixes)
  #destination_address_prefix = azurerm_network_interface.bastion.private_ip_address
  destination_address_prefix = var.destination_address_prefix

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
  tags                = merge(var.tags, { foo = "foo" })
}

resource "azurerm_linux_virtual_machine" "bastion" {
  name                            = "${var.names.product_name}-bastion"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = "Standard_B2s"
  disable_password_authentication = true
  admin_username                  = var.username

  network_interface_ids = [
    azurerm_network_interface.bastion.id,
  ]

  admin_ssh_key {
    username   = var.username
    public_key = var.public_key
  }

  custom_data = base64encode(data.template_file.linux_script.rendered)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}