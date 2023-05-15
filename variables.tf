variable "create_resource_group" {
  type     = bool
  default  = true
  nullable = false
}

variable "location" {
  default = "eastus"
}

variable "resource_group_name" {
  type    = string
  default = null
}

variable "create_vnet_and_subnet" {
  type     = bool
  default  = true
  nullable = false
}

variable "vnet_name" {
  type        = string
  description = "vnet name"
  default     = null
}

variable "vnet_id" {
  type        = string
  description = "vnet id"
  default     = null
}

variable "aks_subnet_name" {
  type        = string
  description = "aks subnet name"
  default     = null
}

variable "appgw_subnet_name" {
  type        = string
  description = "application gateway subnet name"
  default     = null
}


variable "vnet_ip_cidr" {
  type        = list
  description = "vnet ip CIDR"
  default     = null
}

variable "aks_subnet_ip_cidr" {
  type        = list
  description = "aks subnet ip cidr"
  default     = null
}

variable "appgw_subnet_ip_cidr" {
  type        = list
  description = "application gateway subnet ip cidr"
  default     = null
}



variable "private_cluster_enabled" {
  type        = bool
  description = "is private cluster enabled"
  default     = false
}
variable "kubernetes_version" {
  type        = string
  description = "Specify which Kubernetes release to use. The default used is the latest Kubernetes version available in the region"
  default     = null
}

variable "agents_size" {
  type        = string
  description = "The default virtual machine size for the Kubernetes agents. Changing this without specifying `var.temporary_name_for_rotation` forces a new resource to be created."
  default     = "Standard_D2s_v3"
}

variable "cluster_name" {
  type        = string
  description = "(Optional) The name for the AKS resources created in the specified Azure Resource Group. This variable overwrites the 'prefix' var (The 'prefix' var will still be applied to the dns_prefix if it is set)"
  default     = null
}

variable "agents_count" {
  type        = number
  description = "The number of Agents that should exist in the Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes."
  default     = 5
}
variable "cluster_log_analytics_workspace_name" {
  type        = string
  description = "The name of the Analytics workspace"
  default     = null
}
variable "appgw_public_ip_name" {
  type        = string
  description = "The name of application gateway public ip address"
  default     = null
}

variable "appgw_name" {
  type        = string
  description = "The name of application gateway"
  default     = null
}

variable "aks-svc-name" {
  type        = string
  description = "The name of wechat aks service "
  default     = null
}

variable "internal-lb-ip" {
  type        = string
  description = "The interanl load balance ip address"
  default     = null
}

variable "wechat-app-name" {
  type        = string
  description = "The name of wechat app"
  default     = null
}

variable "acr_name" {
  type        = string
  description = "The name of azure container registry"
  default     = null
}
variable "acr_sku" {
  type        = string
  description = "The sku of azure container registry"
  default     = "Standard"

   validation {
    condition     = contains(["Premium", "Standard"], var.acr_sku)
    error_message = "Possible values are `Standard` and `Premium`"
  }
}



