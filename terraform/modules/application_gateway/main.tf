resource "azurerm_public_ip" "agw" {

  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_web_application_firewall_policy" "waf" {

  name                = var.waf_policy_name
  location            = var.location
  resource_group_name = var.resource_group_name

  policy_settings {
    enabled = true
    mode    = "Prevention"
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}

resource "azurerm_application_gateway" "main" {

  name                = var.application_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = var.capacity
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.agw_subnet_id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.agw.id
  }

  backend_address_pool {
    name = "frontend-pool"

    fqdns = [
      var.frontend_fqdn
    ]
  }

  backend_address_pool {
    name = "backend-pool"

    fqdns = [
      var.backend_fqdn
    ]
  }

  probe {
    name        = "backend-probe"
    protocol    = "Https"
    path        = "/health"
    interval    = 30
    timeout     = 30
    unhealthy_threshold = 3

    pick_host_name_from_backend_http_settings = true
  }

  backend_http_settings {

    name                  = "frontend-setting"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 60

    pick_host_name_from_backend_address = true
  }

  backend_http_settings {

    name                  = "backend-setting"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 60

    probe_name = "backend-probe"

    pick_host_name_from_backend_address = true
  }

  http_listener {

    name                           = "listener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  rewrite_rule_set {

    name = "api-rewrite"

    rewrite_rule {

      name          = "remove-api"
      rule_sequence = 100

      condition {
        variable    = "var_uri_path"
        pattern     = "^/api/(.*)"
        ignore_case = true
        negate      = false
      }

      url {
        path    = "/{var_uri_path_1}"
        reroute = false
      }
    }
  }

  url_path_map {

    name = "main-path-map"

    default_backend_address_pool_name  = "frontend-pool"
    default_backend_http_settings_name = "frontend-setting"

    path_rule {

      name = "api-rule"

      paths = [
        "/api/*"
      ]

      backend_address_pool_name  = "backend-pool"
      backend_http_settings_name = "backend-setting"
      rewrite_rule_set_name      = "api-rewrite"
    }
  }

  request_routing_rule {

    name               = "path-routing"
    rule_type          = "PathBasedRouting"
    http_listener_name = "listener"
    url_path_map_name  = "main-path-map"
    priority           = 100
  }

  firewall_policy_id = azurerm_web_application_firewall_policy.waf.id
}
