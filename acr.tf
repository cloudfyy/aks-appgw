resource "azurerm_container_registry" "acr" {
  location            = local.resource_group.location
  name                = var.acr_name
  resource_group_name = local.resource_group.name
  sku                 = var.acr_sku

  retention_policy {
    enabled = var.acr_sku=="Premium" ? true : false
    days    = 7
    
  }
}