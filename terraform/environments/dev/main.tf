module "postgres" {

  source = "./modules/postgres"

  location            = var.location
  resource_group_name = var.resource_group_name

  virtual_network_id = module.networking.vnet_id

  db_subnet_id = module.networking.db_subnet_id

  server_name  = var.postgres_server_name
  database_name = var.postgres_database_name

  admin_username = var.postgres_admin_username

  admin_password = data.azurerm_key_vault_secret.db_password.value
}

module "app_service" {

  source = "./modules/app_service"

  service_plan_name  = var.service_plan_name
  service_plan_sku   = var.service_plan_sku
  app_name           = var.app_service_name

  location            = var.location
  resource_group_name = var.resource_group_name

  app_subnet_id = module.networking.app_subnet_id
  agw_subnet_id = module.networking.agw_subnet_id

  db_host     = module.postgres.db_host
  db_name     = module.postgres.database_name
  db_user     = module.postgres.admin_username
  db_password = data.azurerm_key_vault_secret.db_password.value
  key_vault_id = data.azurerm_key_vault.kv.id

  frontend_url = module.storage.static_website_url
}

module "storage" {
  source = "./modules/storage"

  location            = var.location
  resource_group_name = var.resource_group_name

  account_name = var.storage_account_name
}

module "application_gateway" {

  source = "./modules/application_gateway"

  location            = var.location
  resource_group_name = var.resource_group_name

  public_ip_name = var.public_ip_name

  waf_policy_name = var.waf_policy_name

  application_gateway_name = var.application_gateway_name

  capacity = var.application_gateway_capacity

  agw_subnet_id = module.networking.agw_subnet_id

  frontend_fqdn = module.storage.static_website_hostname

  backend_fqdn = module.app_service.default_hostname
}

module "networking" {

  source = "./modules/networking"

  location            = var.location
  resource_group_name = var.resource_group_name

  vnet_name = var.vnet_name

  vnet_address_space = var.vnet_address_space

  agw_subnet_name = var.agw_subnet_name

  agw_subnet_prefixes = var.agw_subnet_prefixes

  app_subnet_name = var.app_subnet_name

  app_subnet_prefixes = var.app_subnet_prefixes

  db_subnet_name = var.db_subnet_name

  db_subnet_prefixes = var.db_subnet_prefixes
}