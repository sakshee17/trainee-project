variable "location" {
  type = string
}

variable "resource_group_name" {
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

variable "capacity" {
  type    = number
  default = 1
}

variable "agw_subnet_id" {
  type = string
}

variable "frontend_fqdn" {
  type = string
}

variable "backend_fqdn" {
  type = string
}
