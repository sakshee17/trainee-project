resource "azurerm_private_dns_zone" "postgres" {

  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}


resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {

  name                  = "postgres-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name

  virtual_network_id = var.virtual_network_id
}


resource "azurerm_postgresql_flexible_server" "db" {

  name                = var.server_name
  resource_group_name = var.resource_group_name
  location            = var.location

  delegated_subnet_id = var.db_subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.postgres.id

  administrator_login    = var.admin_username
  administrator_password = var.admin_password

  version  = "16"
  sku_name = var.sku_name
  storage_mb = 32768

  public_network_access_enabled = false

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.postgres
  ]

  lifecycle {
    ignore_changes = [
      zone
    ]
  }
}


resource "azurerm_postgresql_flexible_server_database" "app" {

  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.db.id

  charset   = "UTF8"
  collation = "en_US.utf8"
}
