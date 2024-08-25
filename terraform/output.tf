output "resource_group_name" {
  value = azurerm_resource_group.sd3462-rg.name
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.sd3462-aks.name
}