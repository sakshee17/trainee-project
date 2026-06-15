variable "service_plan_name" {
  type = string
}

variable "service_plan_sku" {
  type    = string
  default = "B1"
}

variable "app_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "app_subnet_id" {
  type = string
}

variable "agw_subnet_id" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type = string
}

variable "frontend_url" {
  type = string
}

variable "key_vault_id" {
  type    = string
  default = ""
}
