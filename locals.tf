locals {
  resource_group = {
    name     = var.create_resource_group ? azurerm_resource_group.main[0].name : var.resource_group_name
    location = var.location
  }

  vnet = {
    vnet_name = var.create_vnet_and_subnet ? azurerm_virtual_network.aksvnet[0].name : var.vnet_name
    
  }

   subnets = {
    aks_subnet_id = var.create_vnet_and_subnet ? azurerm_virtual_network.aksvnet[0].id : data.azurerm_subnet.aks-subnet[0].id
    appgw_subnet_id = var.create_vnet_and_subnet ? azurerm_virtual_network.aksvnet[0].id : data.azurerm_subnet.appgw-subnet[0].id
    
  }

  diag_appgw_logs = [
    "ApplicationGatewayAccessLog",
    "ApplicationGatewayPerformanceLog",
    "ApplicationGatewayFirewallLog",
  ]
  diag_appgw_metrics = [
    "AllMetrics",
  ]
}