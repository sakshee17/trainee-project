resource "azurerm_service_plan" "backend" {
  name                = var.service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.service_plan_sku
}

resource "azurerm_linux_web_app" "backend" {
  name                      = var.app_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  service_plan_id           = azurerm_service_plan.backend.id
  virtual_network_subnet_id = var.app_subnet_id

  https_only = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on                         = false
    http2_enabled                     = true
    app_command_line                  = "npm install && npm start"
    health_check_path                 = "/health"
    health_check_eviction_time_in_min = 2

    application_stack {
      node_version = "22-lts"
    }

    ip_restriction {
      name                      = "Allow-AppGateway"
      priority                  = 100
      action                    = "Allow"
      virtual_network_subnet_id = var.agw_subnet_id
    }

    ip_restriction {
      name       = "Explicit-Deny-IPv4"
      priority   = 900
      action     = "Deny"
      ip_address = "0.0.0.0/0"
    }

    ip_restriction {
      name       = "Explicit-Deny-IPv6"
      priority   = 901
      action     = "Deny"
      ip_address = "::/0"
    }

    scm_ip_restriction {
      name                      = "Allow-AppGateway-SCM"
      priority                  = 100
      action                    = "Allow"
      virtual_network_subnet_id = var.agw_subnet_id
    }
  }

  app_settings = {
    NODE_ENV                       = "production"
    PORT                           = "4000"
    DB_HOST                        = var.db_host
    DB_USER                        = var.db_user
    DB_PASSWORD = startswith(var.db_password, "https://") ? "@Microsoft.KeyVault(SecretUri=${var.db_password})" : var.db_password
    DB_PORT                        = "5432"
    DB_NAME                        = var.db_name
    FRONTEND_URL                   = var.frontend_url
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    ENABLE_ORYX_BUILD              = "true"
  }
}


resource "azurerm_role_assignment" "app_kv_access" {
  count                = var.key_vault_id != "" ? 1 : 0
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.backend.identity[0].principal_id
}
