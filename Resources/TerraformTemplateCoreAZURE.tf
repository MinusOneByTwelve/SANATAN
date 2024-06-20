provider "azurerm" {
  features {}
  subscription_id = "AZURESCOPE1VAL"
  client_id       = "AZURESCOPE2VAL"
  client_secret   = "AZURESCOPE3VAL"
  tenant_id       = "AZURESCOPE4VAL"
}

resource "azurerm_resource_group" "THE1VAL1HASHrg" {
  name     = "THE1VAL1HASHrg"
  location = "AZURESCOPE5VAL"
}

resource "azurerm_virtual_network" "THE1VAL1HASHvnet" {
  name                = "THE1VAL1HASHvnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.THE1VAL1HASHrg.location
  resource_group_name = azurerm_resource_group.THE1VAL1HASHrg.name
}

resource "azurerm_subnet" "THE1VAL1HASHsubnet" {
  name                 = "THE1VAL1HASHsubnet"
  resource_group_name  = azurerm_resource_group.THE1VAL1HASHrg.name
  virtual_network_name = azurerm_virtual_network.THE1VAL1HASHvnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "THE1VAL1HASHnsg" {
  name                = "THE1VAL1HASHnsg"
  location            = azurerm_resource_group.THE1VAL1HASHrg.location
  resource_group_name = azurerm_resource_group.THE1VAL1HASHrg.name
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

resource "azurerm_subnet_network_security_group_association" "THE1VAL1HASHsga" {
  subnet_id                 = azurerm_subnet.THE1VAL1HASHsubnet.id
  network_security_group_id = azurerm_network_security_group.THE1VAL1HASHnsg.id
}

resource "azurerm_storage_account" "THE1VAL1HASHsa" {
  name                     = "THE1VAL1F22CHASHsa"
  resource_group_name      = azurerm_resource_group.THE1VAL1HASHrg.name
  location                 = azurerm_resource_group.THE1VAL1HASHrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "THE1VAL1HASHsc" {
  #name                  = "azTHEGLOBALCONTAINERgc"
  name                  = "storage"
  storage_account_name  = azurerm_storage_account.THE1VAL1HASHsa.name
  container_access_type = "private"
}

