variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "virtual_network_id" {
  type = string
}

variable "db_subnet_id" {
  type = string
}

variable "server_name" {
  type = string
}

variable "database_name" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "sku_name" {
  type    = string
  default = "B_Standard_B1ms"
}
