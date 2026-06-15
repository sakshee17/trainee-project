output "static_website_url" {
  value = azurerm_storage_account.sa.primary_web_endpoint
}

output "static_website_hostname" {
  value = trim(replace(azurerm_storage_account.sa.primary_web_endpoint, "https://", ""), "/")
}
