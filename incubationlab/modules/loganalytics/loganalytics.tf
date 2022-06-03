resource "azurerm_log_analytics_workspace" "log" {
    resource_group_name = var.resource_group_name
    location = var.location
    name =var.log_analytics
    retention_in_days = 30
}