# terraform init
$use_existing_vnet = $True
$vnet_rg_name = "rg-aks-vent"
$vnet_name           = "vnet-aks-demo"
$appgw_subnet_name="subnet-appgw-demo"

terraform apply --auto-approve -var vnet_rg_name=$vnet_rg_name -var vnet_name=$vnet_name -var appgw_subnet_name=$appgw_subnet_name -var create_vnet_and_subnet = !$use_existing_vnet
$appgwnsg = terraform output -json | ConvertFrom-Json `
| Select-Object -ExpandProperty "application_gateway_subnet_nsg_id" 

if( $use_existing_vnet -eq $True)
{
    $appgwnsg = az network nsg show --resource-group $vnet_rg_name --name $appgw_subnet_name --query id -o tsv

    az network vnet subnet update --vnet-name $vnet_name --name $appgw_subnet_name --resource-group $vnet_rg_name --network-security-group $appgwnsg.value
}
