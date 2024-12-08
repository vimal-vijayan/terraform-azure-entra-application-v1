variable "custom_app_name" {
  description = "The name of the application."
  type        = string
  default     = null
}

variable "project_name" {
  description = "value of the project name"
  type        = string
}

variable "app_name" {
  description = "The name of the application."
  type        = string
  default     = null
}

variable "environment" {
  description = "The environment of the application."
  type        = string
}

variable "owners" {
  description = "A list of object IDs of principals that will be granted ownership of the application."
  type        = list(string)
}

variable "sign_in_audience" {
  description = "Specifies the Microsoft accounts that are supported for the current application. Possible values are 'AzureADMyOrg', 'AzureADMultipleOrgs', or 'AzureADandPersonalMicrosoftAccount'."
  type        = string
  default     = "AzureADMyOrg"
}

variable "identifier_uris" {
  description = "A list of user-defined URIs that uniquely identify an application within its Azure AD tenant."
  type        = set(string)
  default     = []
}

variable "redirect_uris" {
  description = "A list of redirect URIs for the application."
  type        = list(string)
  default     = []
}

variable "fallback_public_client_enabled" {
  description = "Specifies whether this application is a public client."
  type        = bool
  default     = false
}

variable "marketing_url" {
  description = "The marketing URL of the application."
  type        = string
  default     = null
}

variable "notes" {
  description = "The notes of the application."
  type        = string
  default     = "Managed by Terraform"
}

variable "privacy_statement_url" {
  description = "value of the privacy statement url"
  type        = string
  default     = null
}

variable "service_management_reference" {
  description = "value of the service management reference"
  type        = string
  default     = null
}

variable "support_url" {
  description = "value of the support url"
  type        = string
  default     = null
}

variable "terms_of_service_url" {
  description = "value of the terms of service url"
  type        = string
  default     = null
}

variable "tags" {
  type        = set(string)
  default     = []
  description = "value of the tags"
}

variable "template_id" {
  description = "The ID of the application template."
  type        = string
  default     = null
}

variable "single_page_application" {
  type = object({
    redirect_uris = optional(list(string))
  })
  default     = null
  description = <<EOF
A block defining the single-page application configuration.

Example Usage:
single_page_application = {
  redirect_uris = ["https://myapp.com"]
}
EOF
}

variable "feature_tags" {
  type = object({
    enterprise = optional(bool)
    gallery    = optional(bool)
    hide       = optional(bool)
  })
  default = null

  description = <<EOF

A set of feature tags to assign to the application.

Example Usage:

feature_tags = {
  enterprise = false  # default
  gallery    = false  # default
  hide       = false  # default
}

EOF

}

variable "group_membership_claims" {
  description = "A list of group membership claims that the application requires."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for claim in var.group_membership_claims : claim == "None" ||
      claim == "SecurityGroup" ||
      claim == "DirectoryRole" ||
      claim == "ApplicationGroup" ||
      claim == "All"
    ])
    error_message = "group_membership_claims must be one of 'None', 'SecurityGroup', 'DirectoryRole', 'ApplicationGroup', or 'All'."
  }
}


variable "app_roles" {
  type = list(object({
    allowed_member_types = list(string)
    description          = string
    display_name         = string
    value                = string
  }))
  default     = []
  description = <<EOF
A list of application roles that the application exposes.

Example Usage:

app_roles = [
  {
    allowed_member_types = ["User"]
    description          = "Admins can manage roles and perform all actions."
    display_name         = "Admin"
    is_enabled           = true
    value                = "Admin"
  },
  {
    allowed_member_types = ["User"]
    description          = "Users can read items."
    display_name         = "Reader"
    is_enabled           = true
    value                = "Reader"
  }
]

EOF
}

variable "optional_claims" {
  type = object({
    id_token = optional(list(object({
      name                  = string
      source                = string
      essential             = bool
      additional_properties = list(string)
    })), [])
    access_token = optional(list(object({
      name                  = string
      source                = string
      essential             = bool
      additional_properties = list(string)
    })), [])
    saml2_token = optional(list(object({
      name                  = string
      source                = string
      essential             = bool
      additional_properties = list(string)
    })), [])
  })
  default = null

  description = <<EOF
A set of optional claims to be returned in the JWTs.

Example Usage:

optional_claims = {
  id_token = [
    {
      name                  = "country"
      source                = "user"
      essential             = false
      additional_properties = []
    }
  ]
  access_token = [
    {
      name                  = "country"
      source                = "user"
      essential             = false
      additional_properties = []
    }
  ]
  saml2_token = [
    {
      name                  = "country"
      source                = "user"
      essential             = false
      additional_properties = []
    }
  ]
}

EOF

}


variable "expose_api" {
  type = list(object({
    type                       = optional(string, "User")
    value                      = optional(string, "user_impersonation")
    admin_consent_description  = optional(string, "Allows the app to access the app on your behalf")
    admin_consent_display_name = optional(string, "Access the app on your behalf")
    user_consent_description   = optional(string, "Allow the application to access the app on your behalf")
    user_consent_display_name  = optional(string, "Access the app on your behalf")
    enable_api_permission      = optional(bool, false)
  }))
  default     = []
  description = <<EOF
  A block defining the API to expose."

  Example Usage:

  expose_api = [
    {
      type                       = "User"                                                     # The type of the API permission, allowed values are "User" or "Admin"
      value                      = "user_impersonation"                                       # The value of the API permission
      admin_consent_description  = "Allows the app to access the app on your behalf"
      admin_consent_display_name = "Access the app on your behalf"
      user_consent_description   = "Allow the application to access the app on your behalf"
      user_consent_display_name  = "Access the app on your behalf"
      enable_api_permission      = true                                                       # Enable API permission for the exposed API, default is false
    }
  ]

EOF

}

variable "app_role" {
  description = "A block defining an application role."
  type = list(object({
    enabled              = optional(bool, true)
    id                   = optional(string)
    description          = string
    allowed_member_types = list(string)
    display_name         = string
    value                = string
  }))
  default = null
}


variable "web" {
  description = "A block defining the web configuration."
  type = object({
    redirect_uris = optional(list(string))
    home_page_url = optional(string, null)
    logout_url    = optional(string, null)
    implicit_grant = optional(object({
      access_token_issuance_enabled = optional(bool, false)
      id_token_issuance_enabled     = optional(bool, true)
    }), {})
  })
  default = null
}

variable "public_client" {
  description = "A block defining the public client configuration."
  type = object({
    redirect_uris = optional(list(string))
  })
  default = null
}

variable "api_permissions" {
  type = list(object({
    resource_app = optional(string)
    resource_access = optional(object({
      role_ids  = optional(list(string), [])
      scope_ids = optional(list(string), [])
    }))
  }))
  default = [
    {
      resource_app = "MicrosoftGraph"
      resource_access = {
        scope_ids = ["User.Read"]
      }
    }
  ]

  description = <<EOF
value of the required resource access

Example Usage:

api_permissions = [
  {
    resource_app = "MicrosoftGraph"
    resource_access = {
        role_ids   = ["User.Read.All"]          # A list of valid role id of the resource access or a unique UUID for the resource access
        scope_ids = ["User.Read"]               # A list of valid scope id of the resource access or a unique UUID for the resource access
    }
  }
]

EOF
}

variable "generate_password" {
  description = "Specifies whether to generate a password for the application."
  type        = bool
  default     = false
}


variable "update_key_vault" {
  type = object({
    keyvault_name       = string
    resource_group_name = string
  })
  default     = null
  description = <<EOF
The ID of the key vault to store the application password, The keyvault must exist in the same subscription and region as the original provider block.

Example Usage:

update_key_vault = {
  keyvault_name       = "mykeyvault"            # The name of the key vault
  resource_group_name = "myresourcegroup"       # The name of the resource group, The resource group must be in the same provider subscription as the root module
}

EOF
}


variable "app_role_assignment_required" {
  description = "value of the app role assignment required"
  type        = bool
  default     = false
}

variable "known_client_ids" {
  description = "A list of client IDs of known client applications that are allowed to request a token for this application."
  type        = list(string)
  default     = []
}

