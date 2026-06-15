variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
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

variable "enable_nsg" {
  type    = bool
  default = true
}
