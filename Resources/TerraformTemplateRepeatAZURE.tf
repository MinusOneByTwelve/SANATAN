provider "azurerm" {
  features {}
  subscription_id = "AZURESCOPE1VAL"
  client_id       = "AZURESCOPE2VAL"
  client_secret   = "AZURESCOPE3VAL"
  tenant_id       = "AZURESCOPE4VAL"
}

data "azurerm_resource_group" "THE1VAL1HASHrg" {
  name = "THE1VAL1HASHrg"
}

data "azurerm_virtual_network" "THE1VAL1HASHvnet" {
  name                = "THE1VAL1HASHvnet"
  resource_group_name = data.azurerm_resource_group.THE1VAL1HASHrg.name
}

data "azurerm_subnet" "THE1VAL1HASHsubnet" {
  name                 = "THE1VAL1HASHsubnet"
  virtual_network_name = data.azurerm_virtual_network.THE1VAL1HASHvnet.name
  resource_group_name  = data.azurerm_resource_group.THE1VAL1HASHrg.name
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
  location            = data.azurerm_resource_group.THE1VAL1HASHrg.location
  resource_group_name = data.azurerm_resource_group.THE1VAL1HASHrg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "AZURESCOPEVALnic" {
  count               = var.num_instances
  name                = "AZURESCOPEVALnic-${count.index + 1}"
  location            = data.azurerm_resource_group.THE1VAL1HASHrg.location
  resource_group_name = data.azurerm_resource_group.THE1VAL1HASHrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.THE1VAL1HASHsubnet.id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.AZURESCOPEVALpublic_ip[count.index].id
  }
}

resource "azurerm_storage_account" "AZURESCOPEVALsa" {
  name                     = "THEREQUIREDSTRGACC"
  resource_group_name      = data.azurerm_resource_group.THE1VAL1HASHrg.name
  location                 = data.azurerm_resource_group.THE1VAL1HASHrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_container" "AZURESCOPEVALsc" {
  #name                  = "THEREQUIREDCONTAINER"
  name                  = "bucket"
  storage_account_name  = azurerm_storage_account.AZURESCOPEVALsa.name
  container_access_type = "private"
}

data "azurerm_storage_account" "THE1VAL1HASHsaAZURESCOPEVAL" {
  name                = "THE1VAL1F22CHASHsa"
  resource_group_name = data.azurerm_resource_group.THE1VAL1HASHrg.name
}

data "azurerm_storage_container" "THE1VAL1HASHscAZURESCOPEVAL" {
  #name                  = "azTHEGLOBALCONTAINERgc"
  name                  = "bucket"
  storage_account_name  = data.azurerm_storage_account.THE1VAL1HASHsaAZURESCOPEVAL.name
}

resource "azurerm_linux_virtual_machine" "AZURESCOPEVALvm" {
  count               = var.num_instances
  name                = "AZURESCOPEVAL${count.index + 1}"
  resource_group_name = data.azurerm_resource_group.THE1VAL1HASHrg.name
  location            = data.azurerm_resource_group.THE1VAL1HASHrg.location
  size                = "AZURESCOPE8VAL"
  admin_username      = "AZURESCOPE14VAL"

  admin_ssh_key {
    username   = "AZURESCOPE14VAL"
    public_key = tls_private_key.AZURESCOPEVALssh_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = THEDISKSIZE
  }
  
  identity {
    type = "SystemAssigned"
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

resource "azurerm_role_assignment" "AZURESCOPEVALra" {
  scope                = azurerm_storage_account.AZURESCOPEVALsa.id
  count 	       = length(azurerm_linux_virtual_machine.AZURESCOPEVALvm)
  principal_id         = azurerm_linux_virtual_machine.AZURESCOPEVALvm[count.index].identity[0].principal_id
  role_definition_name = "Storage Blob Data Contributor"
}
resource "azurerm_role_assignment" "AZURESCOPEVALra2" {
  scope                = azurerm_storage_account.AZURESCOPEVALsa.id
  count 	       = length(azurerm_linux_virtual_machine.AZURESCOPEVALvm)
  principal_id         = azurerm_linux_virtual_machine.AZURESCOPEVALvm[count.index].identity[0].principal_id
  role_definition_name = "Storage Blob Data Owner"
}

resource "azurerm_role_assignment" "AZURESCOPEVALraTHE1VAL1HASH" {
  scope                = data.azurerm_storage_account.THE1VAL1HASHsaAZURESCOPEVAL.id
  count 	       = length(azurerm_linux_virtual_machine.AZURESCOPEVALvm)
  principal_id         = azurerm_linux_virtual_machine.AZURESCOPEVALvm[count.index].identity[0].principal_id
  role_definition_name = "Storage Blob Data Contributor"
}
resource "azurerm_role_assignment" "AZURESCOPEVALra2THE1VAL1HASH" {
  scope                = data.azurerm_storage_account.THE1VAL1HASHsaAZURESCOPEVAL.id
  count 	       = length(azurerm_linux_virtual_machine.AZURESCOPEVALvm)
  principal_id         = azurerm_linux_virtual_machine.AZURESCOPEVALvm[count.index].identity[0].principal_id
  role_definition_name = "Storage Blob Data Owner"
}
resource "azurerm_role_assignment" "AZURESCOPEVALra3THE1VAL1HASH" {
  scope                = data.azurerm_storage_account.THE1VAL1HASHsaAZURESCOPEVAL.id
  count 	       = length(azurerm_linux_virtual_machine.AZURESCOPEVALvm)
  principal_id         = azurerm_linux_virtual_machine.AZURESCOPEVALvm[count.index].identity[0].principal_id
  role_definition_name = "Storage File Data SMB Share Contributor"
}
resource "azurerm_role_assignment" "AZURESCOPEVALra4THE1VAL1HASH" {
  scope                = data.azurerm_storage_account.THE1VAL1HASHsaAZURESCOPEVAL.id
  count 	       = length(azurerm_linux_virtual_machine.AZURESCOPEVALvm)
  principal_id         = azurerm_linux_virtual_machine.AZURESCOPEVALvm[count.index].identity[0].principal_id
  role_definition_name = "Storage File Data SMB Share Elevated Contributor"
}
resource "azurerm_role_assignment" "AZURESCOPEVALra5THE1VAL1HASH" {
  scope                = data.azurerm_storage_account.THE1VAL1HASHsaAZURESCOPEVAL.id
  count 	       = length(azurerm_linux_virtual_machine.AZURESCOPEVALvm)
  principal_id         = azurerm_linux_virtual_machine.AZURESCOPEVALvm[count.index].identity[0].principal_id
  role_definition_name = "Storage Account Contributor"
}

