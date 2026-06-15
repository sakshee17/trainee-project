output "db_host" {
  value = azurerm_postgresql_flexible_server.db.fqdn
}

output "server_id" {
  value = azurerm_postgresql_flexible_server.db.id
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.app.name
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.postgres.id
}

output "admin_username" {
  value = var.admin_username
}
