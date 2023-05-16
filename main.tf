resource "random_id" "prefix" {
  byte_length = 8
}

resource "random_string" "acr_suffix" {
  length  = 8
  upper   = false
  numeric = true
  special = false
}

resource "azurerm_user_assigned_identity" "aks_user_assigned_identity_control_plane" {
  location            = local.resource_group.location
  name                = "${var.cluster_name}-cp-identity"
  resource_group_name = local.resource_group.name
}

module "aks" {
  source = "./aks-api"
  
  private_cluster_enabled= var.private_cluster_enabled

  prefix                    = "prefix-${random_id.prefix.hex}"
  resource_group_name       = local.resource_group.name
  kubernetes_version        = var.kubernetes_version # don't specify the patch version!
  #automatic_channel_upgrade = "patch"
  attached_acr_id_map = {
    acr = azurerm_container_registry.acr.id
  }

  
  os_disk_size_gb = 60
  sku_tier        = "Standard"
  rbac_aad        = false
  role_based_access_control_enabled = true
  vnet_subnet_id  = local.subnets.aks_subnet_id
  #net_profile_service_cidr = var.net_profile_service_cidr

  load_balancer_sku = "standard"
  identity_ids                         = [azurerm_user_assigned_identity.aks_user_assigned_identity_control_plane.id]
  identity_type                        = "UserAssigned"
  cluster_name  = var.cluster_name
  rbac_aad_azure_rbac_enabled = false
  enable_auto_scaling = false
  agents_count = var.agents_count
  
  cluster_log_analytics_workspace_name = var.cluster_log_analytics_workspace_name
    
  depends_on = [ 
    azurerm_resource_group.main
   ]
}

/*resource "null_resource" "deploy-internal-load-balancer" {
  depends_on = [
    module.aks
  ]
  provisioner "local-exec" {
      interpreter = ["PowerShell", "-Command"]
      command = <<-EOT
        echo "apiVersion: v1
              kind: Service
              metadata:
                name: internal-app
                annotations:
                  service.beta.kubernetes.io/azure-load-balancer-ipv4: ${internal-lb-ip}
                  service.beta.kubernetes.io/azure-load-balancer-internal: 'true'
              spec:
                type: LoadBalancer
                ports:
                - port: 80
                selector:
                  app: ${internal-app-name}" | kubectl apply -f -
      EOT    

  }
}*/