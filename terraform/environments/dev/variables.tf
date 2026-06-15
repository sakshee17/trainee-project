variable "keyvault_name" {
  type = string
  validation {
    condition     = length(var.keyvault_name) > 0
    error_message = "keyvault_name must not be empty"
  }
}

variable "resource_group_name" {
  type = string
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "resource_group_name must not be empty"
  }
}

variable "location" {
  type = string
  validation {
    condition     = length(var.location) > 0
    error_message = "location must not be empty"
  }
}

variable "frontend_url" {
  type    = string
  default = ""
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "prefix" {
  description = "Naming prefix for resources"
  type        = string
  default     = "trainee"
}

variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
  validation {
    condition     = length(var.vnet_address_space) > 0
    error_message = "vnet_address_space must contain at least one CIDR block"
  }
}

variable "agw_subnet_name" {
  type = string
}

variable "agw_subnet_prefixes" {
  type = list(string)
}

variable "app_subnet_name" {
  type = string
}

variable "app_subnet_prefixes" {
  type = list(string)
}

variable "db_subnet_name" {
  type = string
}

variable "db_subnet_prefixes" {
  type = list(string)
}

variable "postgres_server_name" {
  type = string
  validation {
    condition     = length(var.postgres_server_name) >= 3 && length(var.postgres_server_name) <= 63
    error_message = "postgres_server_name must be between 3 and 63 characters"
  }
}

variable "postgres_database_name" {
  type = string
}

variable "postgres_admin_username" {
  type = string
}

variable "postgres_sku" {
  type    = string
  default = "B_Standard_B1ms"
}

variable "service_plan_name" {
  type = string
}

variable "service_plan_sku" {
  type    = string
  default = "B1"
}

variable "app_service_name" {
  type = string
}

variable "public_ip_name" {
  type = string
}

variable "waf_policy_name" {
  type = string
}

variable "application_gateway_name" {
  type = string
}

variable "application_gateway_capacity" {
  type    = number
  default = 1
}

variable "storage_account_name" {
  type = string
  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "storage_account_name must be 3-24 lowercase letters and numbers"
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}