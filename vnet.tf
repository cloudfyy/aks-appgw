resource "azurerm_virtual_network" "aksvnet" {
  count = var.create_vnet_and_subnet ? 1 : 0
  address_space       = var.vnet_ip_cidr
  location            = local.resource_group.location
  name                = var.vnet_name
  resource_group_name = local.resource_group.name
  lifecycle {    
    precondition {
      condition     = !(var.create_vnet_and_subnet == false && var.vnet_name != null && var.vnet_rg_name !=null && var.aks_subnet_name != null && var.appgw_subnet_name != null)
      error_message = "When skipping creation of vnet and subnet, both vnet_name, vnet_rg_name, appgw_sub_name and aks_subnet_name must be specified"
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



resource "azurerm_network_security_group" "appgwnsg" {
  count = var.create_vnet_and_subnet ? 0 : 1
  name                = "appgw-nsg"
  location            = local.resource_group.location
  resource_group_name = local.resource_group.name

  security_rule {
    name                       = "Allow-65200-65535-For-ApplicationGateway"
    priority = 2800
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

data "azurerm_subnet" "appgw-subnet" {
  count = var.create_vnet_and_subnet ? 0 : 1
  name                 = "${var.appgw_subnet_name}"
  virtual_network_name = "${local.vnet.vnet_name}"
  resource_group_name  = "${var.vnet_rg_name}"
  
}

data "azurerm_subnet" "aks-subnet" {
  count = var.create_vnet_and_subnet ? 0 : 1
  name                 = "${var.aks_subnet_name}"
  virtual_network_name = "${local.vnet.vnet_name}"
  resource_group_name  = "${var.vnet_rg_name}"
  
}

/*resource "azurerm_subnet_network_security_group_association" "appgw-nsg-association" {
  count = var.create_vnet_and_subnet ? 0 : 1
  subnet_id                 = data.azurerm_subnet.appgw-subnet[count.index].id
  network_security_group_id = azurerm_network_security_group.appgwnsg[count.index].id
}*/

