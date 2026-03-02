output "policy_ids" {
  description = "IDs of all custom policy definitions"
  value = {
    deny_rdp_from_internet  = azurerm_policy_definition.deny_rdp_from_internet.id
    deny_ssh_from_internet  = azurerm_policy_definition.deny_ssh_from_internet.id
    deny_public_ip_on_nic   = azurerm_policy_definition.deny_public_ip_on_nic.id
    allowed_locations       = azurerm_policy_definition.allowed_locations.id
    deny_storage_no_https   = azurerm_policy_definition.deny_storage_no_https.id
    deny_storage_public_blob = azurerm_policy_definition.deny_storage_public_blob.id
    audit_diagnostic_settings = azurerm_policy_definition.audit_diagnostic_settings.id
    require_tags            = { for k, v in azurerm_policy_definition.require_tag : k => v.id }
  }
}

output "assignment_ids" {
  description = "IDs of all policy assignments"
  value = {
    deny_rdp_from_internet  = azurerm_subscription_policy_assignment.deny_rdp_from_internet.id
    deny_ssh_from_internet  = azurerm_subscription_policy_assignment.deny_ssh_from_internet.id
    deny_public_ip_on_nic   = azurerm_subscription_policy_assignment.deny_public_ip_on_nic.id
    allowed_locations       = azurerm_subscription_policy_assignment.allowed_locations.id
    deny_storage_no_https   = azurerm_subscription_policy_assignment.deny_storage_no_https.id
    deny_storage_public_blob = azurerm_subscription_policy_assignment.deny_storage_public_blob.id
    audit_diagnostic_settings = azurerm_subscription_policy_assignment.audit_diagnostic_settings.id
    require_tags            = { for k, v in azurerm_subscription_policy_assignment.require_tag : k => v.id }
  }
}