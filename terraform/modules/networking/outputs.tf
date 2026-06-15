output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "agw_subnet_id" {
  value = azurerm_subnet.agw.id
}

output "app_subnet_id" {
  value = azurerm_subnet.app.id
}

output "db_subnet_id" {
  value = azurerm_subnet.db.id
}
