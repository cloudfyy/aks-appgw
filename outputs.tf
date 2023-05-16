output "application_gateway_subnet_nsg_id" {
  
  description = "application gateway subnet nsg id"
  value = azurerm_network_security_group.appgwnsg[0].id

}
