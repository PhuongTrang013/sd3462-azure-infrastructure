# Create a resource group
resource "azurerm_resource_group" "sd3462-rg" {
  name     = "sd3462-resource-gr"
  location = "eastus"
}

# Create a virtual network
resource "azurerm_virtual_network" "sd3462-vnet" {
  name                = "sd3462-network"
  location            = azurerm_resource_group.sd3462-rg.location
  resource_group_name = azurerm_resource_group.sd3462-rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet-1"
  resource_group_name  = azurerm_resource_group.sd3462-rg.name
  virtual_network_name = azurerm_virtual_network.sd3462-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# create container registry
resource "azurerm_container_registry" "sd3462-acr" {
  name                = "sd3462acr"
  location            = azurerm_resource_group.sd3462-rg.location
  resource_group_name = azurerm_resource_group.sd3462-rg.name
  sku                 = "Standard"
  admin_enabled       = true
}

# create AKS Cluster
resource "azurerm_kubernetes_cluster" "sd3462-aks" {
  name                = "sd3462-aks"
  location            = azurerm_resource_group.sd3462-rg.location
  resource_group_name = azurerm_resource_group.sd3462-rg.name
  dns_prefix          = "sd3462-aks1"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_A2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}

# create role assignment for aks acr pull
resource "azurerm_role_assignment" "aks-acr-role" {
  principal_id                     = azurerm_kubernetes_cluster.sd3462-aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.sd3462-acr.id
  skip_service_principal_aad_check = true
}