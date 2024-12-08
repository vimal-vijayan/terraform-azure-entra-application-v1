data "azuread_users" "owners" {
  user_principal_names = var.owners
}

# rotating the secret every 365 days
resource "time_rotating" "rotate365" {
  count         = var.generate_password ? 1 : 0
  rotation_days = 365
}

locals {
  app_display_name                = var.custom_app_name != null ? "${var.custom_app_name}" : "spa-${var.app_name}-${var.project_name}-${var.environment}"
  require_password                = var.generate_password ? [1] : []
  require_feature_tags            = var.feature_tags != null ? [1] : []
  require_single_page_application = var.single_page_application != null ? [1] : []
  require_optional_claims         = var.optional_claims != null ? [1] : []
  require_web                     = var.web != null ? [1] : []
  require_public_client           = var.public_client != null ? [1] : []
  require_key_vault               = var.update_key_vault != null ? 1 : 0
  require_known_clients           = length(var.known_client_ids) > 0 ? 1 : 0

  # Generate key vault secret names
  kv_client_id_name     = var.update_key_vault != null ? replace(replace("${var.app_name}-clientid", "_", "-"), " ", "-") : ""
  kv_client_secret_name = var.update_key_vault != null ? replace(replace("${var.app_name}-secret", "_", "-"), " ", "-") : ""

  # setting the tags for application manifest
  default_tags = [
    "EssityOwner: ${join(",", var.owners)}",
    "EssityDescription: This SPA is used in ${var.project_name}",
    "Environment: ${var.environment}",
    "Project: ${var.project_name}",
  ]

  tags = concat(var.update_key_vault != null ? concat(local.default_tags, [
    "Keyvault: ${var.update_key_vault.name}",
    "Secret: ${var.update_key_vault.resource_group_name}",
  ]) : local.default_tags, tolist(var.tags))

}


# Creating the azure ad application
resource "azuread_application" "application" {
  display_name                   = local.app_display_name
  owners                         = data.azuread_users.owners.object_ids
  sign_in_audience               = var.sign_in_audience
  prevent_duplicate_names        = true
  fallback_public_client_enabled = var.fallback_public_client_enabled
  group_membership_claims        = var.group_membership_claims
  marketing_url                  = var.marketing_url
  privacy_statement_url          = var.privacy_statement_url
  support_url                    = var.support_url
  template_id                    = var.template_id
  tags                           = local.tags
  terms_of_service_url           = var.terms_of_service_url

  lifecycle {
    ignore_changes = [identifier_uris, api, required_resource_access, app_role]
  }

  notes                        = var.notes
  service_management_reference = var.service_management_reference

  # Enabling the enterprise and gallery feature tags
  dynamic "feature_tags" {
    for_each = local.require_feature_tags
    content {
      enterprise = var.feature_tags.enterprise
      gallery    = var.feature_tags.gallery
      hide       = var.feature_tags.hide
    }
  }

  dynamic "single_page_application" {
    for_each = local.require_single_page_application
    content {
      redirect_uris = var.single_page_application.redirect_uris
    }
  }

  dynamic "optional_claims" {
    for_each = local.require_optional_claims
    content {
      dynamic "access_token" {
        for_each = { for key, value in var.optional_claims.access_token : value.name => value }
        content {
          name                  = access_token.value.name
          source                = access_token.value.source
          essential             = access_token.value.essential
          additional_properties = access_token.value.additional_properties
        }
      }

      dynamic "id_token" {
        for_each = { for key, value in var.optional_claims.id_token : value.name => value }
        content {
          name                  = id_token.value.name
          source                = id_token.value.source
          essential             = id_token.value.essential
          additional_properties = id_token.value.additional_properties
        }
      }

      dynamic "saml2_token" {
        for_each = { for key, value in var.optional_claims.saml2_token : value.name => value }
        content {
          name                  = saml2_token.value.name
          source                = saml2_token.value.source
          essential             = saml2_token.value.essential
          additional_properties = saml2_token.value.additional_properties
        }
      }
    }
  }

  dynamic "web" {
    for_each = local.require_web
    content {
      redirect_uris = var.web.redirect_uris
      homepage_url  = var.web.home_page_url
      logout_url    = var.web.logout_url
      dynamic "implicit_grant" {
        for_each = var.web.implicit_grant != null ? [1] : []
        content {
          access_token_issuance_enabled = var.web.implicit_grant.access_token_issuance_enabled
          id_token_issuance_enabled     = var.web.implicit_grant.id_token_issuance_enabled
        }
      }
    }
  }

  dynamic "public_client" {
    for_each = local.require_public_client
    content {
      redirect_uris = var.public_client.redirect_uris
    }
  }

  # creating the secret for the argocd application
  dynamic "password" {
    for_each = local.require_password
    content {
      display_name = "Password generated by Terraform on ${time_rotating.rotate365[0].id}"
      start_date   = time_rotating.rotate365[0].id
      end_date     = timeadd(time_rotating.rotate365[0].id, "4320h")
    }
  }

  # group_membership_claims = ["ApplicationGroup"]
}

# Creating the service principal
resource "azuread_service_principal" "service_principal" {
  client_id                    = azuread_application.application.client_id
  app_role_assignment_required = var.app_role_assignment_required
  owners                       = data.azuread_users.owners.object_ids
}

# Identifier URI
resource "azuread_application_identifier_uri" "identifier_uris" {
  for_each       = toset(var.identifier_uris)
  application_id = azuread_application.application.id
  identifier_uri = each.key == "self" ? "api://${azuread_application.application.client_id}" : each.value
}

# Expose API :
resource "random_uuid" "api_scope_id" {
  for_each = { for key, value in var.expose_api : "${value.type}_${value.value}_${key}" => value }
}

resource "azuread_application_permission_scope" "expose_api" {
  for_each                   = { for key, value in var.expose_api : "${value.type}_${value.value}_${key}" => value }
  application_id             = azuread_application.application.id
  scope_id                   = random_uuid.api_scope_id[each.key].result
  value                      = each.value.value
  admin_consent_description  = each.value.admin_consent_description
  admin_consent_display_name = each.value.admin_consent_display_name
}

# API Access for the exposed API
resource "azuread_application_api_access" "api_access" {
  for_each       = { for key, value in var.expose_api : "${value.type}_${value.value}_${key}" => value if value.enable_api_permission }
  application_id = azuread_application.application.id
  api_client_id  = azuread_application.application.client_id

  scope_ids = [azuread_application_permission_scope.expose_api[each.key].scope_id]
}

# API Permissions
data "azuread_application_published_app_ids" "well_known" {}

data "azuread_service_principal" "graph_api" {
  for_each  = { for key, value in var.api_permissions : value.resource_app => value }
  client_id = try(data.azuread_application_published_app_ids.well_known.result[each.value.resource_app], each.value.resource_app)
}

resource "azuread_application_api_access" "graph_api_access" {
  for_each       = { for key, value in var.api_permissions : value.resource_app => value }
  application_id = azuread_application.application.id
  api_client_id  = try(data.azuread_application_published_app_ids.well_known.result[each.value.resource_app], each.value.resource_app)

  role_ids = [
    for role in each.value.resource_access.role_ids : try(data.azuread_service_principal.graph_api[each.value.resource_app].app_role_ids[role], role)
  ]
  scope_ids = [
    for scope in each.value.resource_access.scope_ids : try(data.azuread_service_principal.graph_api[each.value.resource_app].oauth2_permission_scope_ids[scope], scope)
  ]
}

# Known Client Applications
resource "azuread_application_known_clients" "known_clients" {
  count            = local.require_known_clients
  application_id   = azuread_application.application.id
  known_client_ids = var.known_client_ids
}

## Check : https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment
# App Role Assignments
resource "random_uuid" "app_role_uuid" {
  for_each = { for key, value in var.app_roles : value.display_name => value }
}

resource "azuread_application_app_role" "app_roles" {
  for_each       = { for key, value in var.app_roles : value.display_name => value }
  application_id = azuread_application.application.id
  role_id        = random_uuid.app_role_uuid[each.key].result

  allowed_member_types = each.value.allowed_member_types
  description          = each.value.description
  display_name         = each.value.display_name
  value                = each.value.value
}
