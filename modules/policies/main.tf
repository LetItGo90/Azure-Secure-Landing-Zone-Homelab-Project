data "azurerm_subscription" "current" {}


resource "azurerm_policy_definition" "deny_rdp_from_internet" {
  name         = "deny-rdp-from-internet"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny RDP from Internet"

  policy_rule = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Network/networkSecurityGroups/securityRules"
        },
        {
          "field": "Microsoft.Network/networkSecurityGroups/securityRules/direction",
          "equals": "Inbound"
        },
        {
          "field": "Microsoft.Network/networkSecurityGroups/securityRules/access",
          "equals": "Allow"
        },
        {
          "field": "Microsoft.Network/networkSecurityGroups/securityRules/destinationPortRange",
          "equals": "3389"
        },
        {
          "field": "Microsoft.Network/networkSecurityGroups/securityRules/sourceAddressPrefix",
          "in": ["*", "Internet"]
        }
      ]
    },
    "then": {
      "effect": "Deny"
    }
  }
  POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "deny_rdp_from_internet" {
  name                 = "deny-rdp-from-internet"
  display_name         = "Deny RDP from Internet"
  policy_definition_id = azurerm_policy_definition.deny_rdp_from_internet.id
  subscription_id      = data.azurerm_subscription.current.id
}


resource "azurerm_policy_definition" "deny_ssh_from_internet" {
  name         = "deny-ssh-from-internet"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny SSH from Internet"

  policy_rule = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Network/networkSecurityGroups/securityRules"
        },
        {
          "field": "Microsoft.Network/networkSecurityGroups/securityRules/direction",
          "equals": "Inbound"
        },
        {
          "field": "Microsoft.Network/networkSecurityGroups/securityRules/access",
          "equals": "Allow"
        },
        {
          "field": "Microsoft.Network/networkSecurityGroups/securityRules/destinationPortRange",
          "equals": "22"
        },
        {
          "field": "Microsoft.Network/networkSecurityGroups/securityRules/sourceAddressPrefix",
          "in": ["*", "Internet"]
        }
      ]
    },
    "then": {
      "effect": "Deny"
    }
  }
  POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "deny_ssh_from_internet" {
  name                 = "deny-ssh-from-internet"
  display_name         = "Deny SSH from Internet"
  policy_definition_id = azurerm_policy_definition.deny_ssh_from_internet.id
  subscription_id      = data.azurerm_subscription.current.id
}


resource "azurerm_policy_definition" "deny_public_ip_on_nic" {
  name         = "deny-public-ip-on-nic"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny Public IP on NIC"

  policy_rule = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Network/networkInterfaces"
        },
        {
          "not": {
            "field": "Microsoft.Network/networkInterfaces/ipconfigurations[*].publicIpAddress.id",
            "notLike": "*"
          }
        }
      ]
    },
    "then": {
      "effect": "Deny"
    }
  }
  POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "deny_public_ip_on_nic" {
  name                 = "deny-public-ip-on-nic"
  display_name         = "Deny Public IP on NIC"
  policy_definition_id = azurerm_policy_definition.deny_public_ip_on_nic.id
  subscription_id      = data.azurerm_subscription.current.id
}

resource "azurerm_policy_definition" "allowed_locations" {
  name         = "allowed-locations"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed Locations"

  policy_rule = <<POLICY_RULE
  {
    "if": {
      "not": {
        "field": "location",
        "in": ["eastus", "eastus2", "global"]
      }
    },
    "then": {
      "effect": "Deny"
    }
  }
  POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations"
  display_name         = "Allowed Locations"
  policy_definition_id = azurerm_policy_definition.allowed_locations.id
  subscription_id      = data.azurerm_subscription.current.id
}


resource "azurerm_policy_definition" "require_tag" {
  for_each = toset(["Environment", "Owner", "CostCenter", "ManagedBy"])

  name         = "require-tag-${lower(each.key)}"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Require tag: ${each.key}"

  policy_rule = <<POLICY_RULE
  {
    "if": {
      "field": "[concat('tags[', '${each.key}', ']')]",
      "exists": "false"
    },
    "then": {
      "effect": "Audit"
    }
  }
  POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "require_tag" {
  for_each = azurerm_policy_definition.require_tag

  name                 = each.value.name
  display_name         = each.value.display_name
  policy_definition_id = each.value.id
  subscription_id      = data.azurerm_subscription.current.id
}


resource "azurerm_policy_definition" "deny_storage_no_https" {
  name         = "deny-storage-no-https"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny Storage Accounts without HTTPS"

  policy_rule = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Storage/storageAccounts"
        },
        {
          "field": "Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly",
          "notEquals": "true"
        }
      ]
    },
    "then": {
      "effect": "Deny"
    }
  }
  POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "deny_storage_no_https" {
  name                 = "deny-storage-no-https"
  display_name         = "Deny Storage Accounts without HTTPS"
  policy_definition_id = azurerm_policy_definition.deny_storage_no_https.id
  subscription_id      = data.azurerm_subscription.current.id
}


resource "azurerm_policy_definition" "deny_storage_public_blob" {
  name         = "deny-storage-public-blob"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny Storage Accounts with Public Blob Access"

  policy_rule = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Storage/storageAccounts"
        },
        {
          "field": "Microsoft.Storage/storageAccounts/allowBlobPublicAccess",
          "notEquals": "false"
        }
      ]
    },
    "then": {
      "effect": "Deny"
    }
  }
  POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "deny_storage_public_blob" {
  name                 = "deny-storage-public-blob"
  display_name         = "Deny Storage Accounts with Public Blob Access"
  policy_definition_id = azurerm_policy_definition.deny_storage_public_blob.id
  subscription_id      = data.azurerm_subscription.current.id
}



resource "azurerm_policy_definition" "audit_diagnostic_settings" {
  name         = "audit-diagnostic-settings"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Audit Resources without Diagnostic Settings"

  policy_rule = <<POLICY_RULE
  {
    "if": {
      "field": "type",
      "notEquals": ""
    },
    "then": {
      "effect": "AuditIfNotExists",
      "details": {
        "type": "Microsoft.Insights/diagnosticSettings"
      }
    }
  }
  POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "audit_diagnostic_settings" {
  name                 = "audit-diagnostic-settings"
  display_name         = "Audit Resources without Diagnostic Settings"
  policy_definition_id = azurerm_policy_definition.audit_diagnostic_settings.id
  subscription_id      = data.azurerm_subscription.current.id
}