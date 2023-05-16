resource "azurerm_public_ip" "pip" {
  name                = var.appgw_public_ip_name
  resource_group_name = local.resource_group.name
  location            = local.resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
  //zones = [1, 2, 3]
}

# -
# - Log Analytics Workspace
# -
resource "azurerm_log_analytics_workspace" "wks" {
  name                = "${var.appgw_name}-wks"
  location            = local.resource_group.location
  resource_group_name = local.resource_group.name
  sku                 = "PerGB2018" #(Required) Specifies the Sku of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018 (new Sku as of 2018-04-03).
  retention_in_days   = 100         #(Optional) The workspace data retention in days. Possible values range between 30 and 730.
  
}

resource "azurerm_log_analytics_solution" "agw" {
  solution_name         = "AzureAppGatewayAnalytics"
  location              = local.resource_group.location
  resource_group_name   = local.resource_group.name
  workspace_resource_id = azurerm_log_analytics_workspace.wks.id
  workspace_name        = azurerm_log_analytics_workspace.wks.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/AzureAppGatewayAnalytics"
  }
}

resource "azurerm_application_gateway" "appgw" {
  name                = var.appgw_name
  resource_group_name = local.resource_group.name
  location            = local.resource_group.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  /*autoscale_configuration {
    min_capacity = 1
    max_capacity = 15
  }*/

  //zones = [1, 2, 3]

  gateway_ip_configuration {
    name      = "${var.appgw_name}-ip-configuration"
    subnet_id = local.subnets.appgw_subnet_id
  }

  frontend_port {
    name = "${var.appgw_name}-frontend-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "${var.appgw_name}-frontend-ip-configuration"
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  backend_address_pool {
    name = "${var.appgw_name}-backend-address-pool"
  }

  backend_http_settings {
    name                  = "${var.appgw_name}-backend-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "${var.appgw_name}-http-listener-name"
    frontend_ip_configuration_name = "${var.appgw_name}-frontend-ip-configuration"
    frontend_port_name             = "${var.appgw_name}-frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${var.appgw_name}-request-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "${var.appgw_name}-http-listener-name"
    backend_address_pool_name  = "${var.appgw_name}-backend-address-pool"
    backend_http_settings_name = "${var.appgw_name}-backend-http-settings"
    priority                   = 1
  }

   identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.agw.id]
  }

  /*ssl_certificate {
    name = "aks-svc-cert"
    key_vault_secret_id = azurerm_key_vault_certificate.wechataks.secret_id
  }*/
}

#
# Diagnostic Settings
#

/*resource "azurerm_monitor_diagnostic_setting" "agw" {
  name                       = "${var.appgw_name}-monitor"
  target_resource_id         = azurerm_application_gateway.appgw.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.wks.id
  dynamic "enabled_log" {
    for_each = local.diag_appgw_logs
    content {
      category = enabled_log.value

      retention_policy {
        enabled = false
      }
    }
  }

  dynamic "metric" {
    for_each = local.diag_appgw_metrics
    content {
      category = metric.value

      retention_policy {
        enabled = false
      }
    }
  }
}*/

