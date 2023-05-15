create_resource_group=false
resource_group_name = "rg-aks-demo"
location            = "eastus"
#network configuration
create_vnet_and_subnet = false
/*vnet_name           = "vnet-aks-demo"
vnet_ip_cidr           = ["10.52.0.0/16"]
aks_subnet_name         = "subnet-aks-demo"
aks_subnet_ip_cidr  = ["10.52.0.0/24"]
appgw_subnet_name         = "subnet-appgw-demo"
appgw_subnet_ip_cidr  = ["10.52.1.0/24"]*/
vnet_id="/subscriptions/595c5281-dd90-4ddf-9a98-e874a28529d0/resourceGroups/rg-aks-demo/providers/Microsoft.Network/virtualNetworks/vnet-aks-demo"
aks_subnet_name="subnet-aks-demo"
appgw_subnet_name="subnet-appgw-demo"

#acr configuration
acr_name="qiqiaksacrdemo"
acr_sku="Standard"

#aks configuration
private_cluster_enabled=true
agents_size         = "Standard_E2s_v3"
cluster_name        = "qiqi-aks-demo"
agents_count        = 5
kubernetes_version  = "1.26.3"
cluster_log_analytics_workspace_name="qiqiaks-wkspc"
#net_profile_service_cidr="10.52.10.0/24"

#application gateway configuration
appgw_public_ip_name="qiqi-aks-appgw-demo-ip"
appgw_name= "qiqi-aks-appgw-demo"
# 将来这里会增加端口配置，HTTP规则等

#Service configuration
#这个AKS服务的名字，现在随便起即可
aks-svc-name="qiqi-aks-svc-demo"
