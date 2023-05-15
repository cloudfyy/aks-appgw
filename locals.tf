locals {
  resource_group = {
    name     = var.create_resource_group ? azurerm_resource_group.main[0].name : var.resource_group_name
    location = var.location
  }

  vnet = {
    vnet_name = var.create_vnet_and_subnet ? azurerm_virtual_network.aksvnet[0].name : var.vnet_name
    
  }

  subnet = {
    aks_subnet_id = var.create_vnet_and_subnet ? azurerm_subnet.akssubnet[0].id : "${var.vnet_id}/subnets/${var.aks_subnet_name}"
    appgw_subnet_id = var.create_vnet_and_subnet ? azurerm_subnet.appgwsubnet[0].id : "${var.vnet_id}/subnets/${var.appgw_subnet_name}"
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