resource "azurerm_storage_account" "sa" {
  name                     = var.account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  
  network_rules {
    default_action             = "Allow"
  }

}

resource "azurerm_storage_account_static_website" "static" {
  storage_account_id = azurerm_storage_account.sa.id
  index_document     = "index.html"
  error_404_document = "404.html"
}

