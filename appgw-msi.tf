# -
# - Managed Service Identity
# -

resource "azurerm_user_assigned_identity" "agw" {
  location                   = local.resource_group.location
  resource_group_name        = local.resource_group.name
  name                = "${var.appgw_name}-msi"
  
}