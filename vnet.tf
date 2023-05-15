resource "azurerm_virtual_network" "aksvnet" {
  count = var.create_vnet_and_subnet ? 1 : 0
  address_space       = var.vnet_ip_cidr
  location            = local.resource_group.location
  name                = var.vnet_name
  resource_group_name = local.resource_group.name
  lifecycle {    
    precondition {
      condition     = !(var.create_vnet_and_subnet == false && var.vnet_id != null && var.aks_subnet_name != null && var.appgw_subnet_name != null)
      error_message = "When skipping creation of vnet and subnet, both appgw_subnet_id and aks_subnet_id must be specified"
    }

      precondition {
      condition     = !(var.create_vnet_and_subnet == true && (var.vnet_name == null || var.vnet_ip_cidr == null || var.aks_subnet_name == null || var.aks_subnet_ip_cidr == null || var.appgw_subnet_name == null || var.appgw_subnet_ip_cidr == null))
      error_message = "When creating vnet and subnet, vnet_name and subnet info must be specified"
    }
  }
}

resource "azurerm_subnet" "akssubnet" {
  count = var.create_vnet_and_subnet ? 1 : 0
  address_prefixes                               = var.aks_subnet_ip_cidr
  name                                           = var.aks_subnet_name
  resource_group_name                            = local.resource_group.name
  virtual_network_name                           = local.vnet.vnet_name
  #enforce_private_link_endpoint_network_policies = true
  private_endpoint_network_policies_enabled       =true
}

resource "azurerm_subnet" "appgwsubnet" {
  count = var.create_vnet_and_subnet ? 1 : 0
  address_prefixes                               = var.appgw_subnet_ip_cidr
  name                                           = var.appgw_subnet_name
  resource_group_name                            = local.resource_group.name
  virtual_network_name                           = local.vnet.vnet_name
  #enforce_private_link_endpoint_network_policies = true
  private_endpoint_network_policies_enabled       =true
}

