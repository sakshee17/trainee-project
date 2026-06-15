resource "azurerm_virtual_network" "main" {

  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name

  address_space = var.vnet_address_space
}


resource "azurerm_subnet" "agw" {

  name                 = var.agw_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = var.agw_subnet_prefixes

  service_endpoints = [
    "Microsoft.Web"
  ]
}


resource "azurerm_subnet" "app" {

  name                 = var.app_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = var.app_subnet_prefixes

  delegation {

    name = "web"

    service_delegation {

      name = "Microsoft.Web/serverFarms"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}


resource "azurerm_subnet" "db" {

  name                 = var.db_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = var.db_subnet_prefixes

  delegation {

    name = "postgres"

    service_delegation {

      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}


resource "azurerm_network_security_group" "db_nsg" {
  count               = var.enable_nsg ? 1 : 0
  name                = "${var.vnet_name}-db-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-App-To-DB"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefixes    = var.app_subnet_prefixes
    destination_port_range     = "5432"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "db_nsg_assoc" {
  count                    = var.enable_nsg ? 1 : 0
  subnet_id                = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.db_nsg[0].id
}

resource "azurerm_network_security_group" "app_nsg" {
  count               = var.enable_nsg ? 1 : 0
  name                = "${var.vnet_name}-app-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-AGW-To-App"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefixes    = var.agw_subnet_prefixes
    destination_port_range     = "443"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "app_nsg_assoc" {
  count                    = var.enable_nsg ? 1 : 0
  subnet_id                = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app_nsg[0].id
}

