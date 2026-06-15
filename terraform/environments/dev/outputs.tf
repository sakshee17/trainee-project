output "app_url" {
  value = module.app_service.default_hostname
}

output "application_gateway_public_ip" {
  value = module.application_gateway.public_ip
}

output "database_host" {
  value = module.postgres.db_host
}

output "storage_static_website_url" {
  value = module.storage.static_website_url
}
