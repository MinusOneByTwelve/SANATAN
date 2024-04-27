provider "azurerm" {
  features {}
  subscription_id = "AZURESCOPE1VAL"
  client_id       = "AZURESCOPE2VAL"
  client_secret   = "AZURESCOPE3VAL"
  tenant_id       = "AZURESCOPE4VAL"
}

resource "azurerm_resource_group" "AZURESCOPEVALrg" {
  name     = "AZURESCOPEVALrg"
  location = "AZURESCOPE5VAL"
}

resource "azurerm_virtual_network" "AZURESCOPEVALvnet" {
  name                = "AZURESCOPEVALvnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.AZURESCOPEVALrg.location
  resource_group_name = azurerm_resource_group.AZURESCOPEVALrg.name
}

resource "azurerm_subnet" "AZURESCOPEVALsubnet" {
  name                 = "AZURESCOPEVALsubnet"
  resource_group_name  = azurerm_resource_group.AZURESCOPEVALrg.name
  virtual_network_name = azurerm_virtual_network.AZURESCOPEVALvnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "tls_private_key" "AZURESCOPEVALssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "AZURESCOPEVALssh_private_key" {
  filename = "AZURESCOPE6VAL"
  content  = tls_private_key.AZURESCOPEVALssh_key.private_key_pem
}

variable "num_instances" {
  default = AZURESCOPE7VAL
}

resource "azurerm_public_ip" "AZURESCOPEVALpublic_ip" {
  count               = var.num_instances
  name                = "AZURESCOPEVALpublicip-${count.index + 1}"
  location            = azurerm_resource_group.AZURESCOPEVALrg.location
  resource_group_name = azurerm_resource_group.AZURESCOPEVALrg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "AZURESCOPEVALnic" {
  count               = var.num_instances
  name                = "AZURESCOPEVALnic-${count.index + 1}"
  location            = azurerm_resource_group.AZURESCOPEVALrg.location
  resource_group_name = azurerm_resource_group.AZURESCOPEVALrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.AZURESCOPEVALsubnet.id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.AZURESCOPEVALpublic_ip[count.index].id
  }
}

resource "azurerm_network_security_group" "AZURESCOPEVALnsg" {
  name                = "AZURESCOPEVALnsg"
  location            = azurerm_resource_group.AZURESCOPEVALrg.location
  resource_group_name = azurerm_resource_group.AZURESCOPEVALrg.name
AZURESCOPE13VAL
  security_rule {
    name                       = "AllowSSH"
    priority                   = 3001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowPing"
    priority                   = 3002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    
  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 2001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }  
}

resource "azurerm_subnet_network_security_group_association" "AZURESCOPEVALsga" {
  subnet_id                 = azurerm_subnet.AZURESCOPEVALsubnet.id
  network_security_group_id = azurerm_network_security_group.AZURESCOPEVALnsg.id
}

resource "azurerm_linux_virtual_machine" "AZURESCOPEVALvm" {
  count               = var.num_instances
  name                = "AZURESCOPEVAL${count.index + 1}"
  resource_group_name = azurerm_resource_group.AZURESCOPEVALrg.name
  location            = azurerm_resource_group.AZURESCOPEVALrg.location
  size                = "AZURESCOPE8VAL"
  admin_username      = "AZURESCOPE14VAL"

  admin_ssh_key {
    username   = "AZURESCOPE14VAL"
    public_key = tls_private_key.AZURESCOPEVALssh_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "AZURESCOPE9VAL"
    offer     = "AZURESCOPE10VAL"
    sku       = "AZURESCOPE11VAL"
    version   = "AZURESCOPE12VAL"
  }

  network_interface_ids = [azurerm_network_interface.AZURESCOPEVALnic[count.index].id]
}

output "public_ips" {
  value = azurerm_linux_virtual_machine.AZURESCOPEVALvm[*].public_ip_address
}

output "hostnames" {
  value = azurerm_linux_virtual_machine.AZURESCOPEVALvm[*].name
}

