# Introduction 
TODO: Create Entra ID Application and Service Principal

# Example Usage
```
module "app" {
  source = "Use the latest source"

  project_name    = "project1"
  custom_app_name = "app1-dummy-name"
  owners          = ["owner1@essity.com]
  environment     = "dev"
  api_permissions = [{
    resource_app = "MicrosoftGraph"
    resource_access = {
      scope_ids = ["email", "openid", "profile", "Sites.Read.All", "Sites.Selected", "User.Read"]
    }
    },
    {
      resource_app = "DynamicsCrm"
      resource_access = {
        scope_ids = ["78ce3f0f-a1ce-49c2-8cde-64b5c0896db4"]
      }
  }]
  expose_api = [{
    value                      = "user_impersonation"
    enable_api_permission      = true
    admin_consent_display_name = "Access app"
    admin_consent_description  = "Allow the application to access app on behalf of the signed-in user."
    user_consent_display_name  = "Access app"
    user_consent_description   = "Allow the application to access app on your behalf."
  }]
  single_page_application = {
    redirect_uris = ["https://redirecturis.com"]
  }
  web = {
    home_page_url = "https://app.azurewebsites.net"
    redirect_uris = ["https://redirect.uri.if.any"]
  }
  identifier_uris = ["self"]
}

```

# Contribute
create feature branches and PR

If you want to learn more about creating good readme files then refer the following [guidelines](https://docs.microsoft.com/en-us/azure/devops/repos/git/create-a-readme?view=azure-devops). You can also seek inspiration from the below readme files:
- [ASP.NET Core](https://github.com/aspnet/Home)
- [Visual Studio Code](https://github.com/Microsoft/vscode)
- [Chakra Core](https://github.com/Microsoft/ChakraCore)
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.0.2 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.11.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.12.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.application](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_api_access.api_access](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_api_access) | resource |
| [azuread_application_api_access.graph_api_access](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_api_access) | resource |
| [azuread_application_identifier_uri.identifier_uris](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_identifier_uri) | resource |
| [azuread_application_known_clients.known_clients](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_known_clients) | resource |
| [azuread_application_permission_scope.expose_api](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_permission_scope) | resource |
| [azuread_service_principal.service_principal](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_key_vault_secret.aad_appclient_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.client_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [random_uuid.api_scope_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [time_rotating.rotate365](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |
| [azuread_application_published_app_ids.well_known](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application_published_app_ids) | data source |
| [azuread_service_principal.graph_api](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azuread_users.owners](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users) | data source |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_permissions"></a> [api\_permissions](#input\_api\_permissions) | value of the required resource access<br/><br/>Example Usage:<br/><br/>api\_permissions = [<br/>  {<br/>    resource\_app = "MicrosoftGraph"<br/>    resource\_access = {<br/>        role\_ids   = ["User.Read.All"]          # A list of valid role id of the resource access or a unique UUID for the resource access<br/>        scope\_ids = ["User.Read"]               # A list of valid scope id of the resource access or a unique UUID for the resource access<br/>    }<br/>  }<br/>] | <pre>list(object({<br/>    resource_app = optional(string)<br/>    resource_access = optional(object({<br/>      role_ids  = optional(list(string), [])<br/>      scope_ids = optional(list(string), [])<br/>    }))<br/>  }))</pre> | <pre>[<br/>  {<br/>    "resource_access": {<br/>      "scope_ids": [<br/>        "User.Read"<br/>      ]<br/>    },<br/>    "resource_app": "MicrosoftGraph"<br/>  }<br/>]</pre> | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | The name of the application. | `string` | `null` | no |
| <a name="input_app_role"></a> [app\_role](#input\_app\_role) | A block defining an application role. | <pre>list(object({<br/>    enabled              = optional(bool, true)<br/>    id                   = optional(string)<br/>    description          = string<br/>    allowed_member_types = list(string)<br/>    display_name         = string<br/>    value                = string<br/>  }))</pre> | `null` | no |
| <a name="input_app_role_assignment_required"></a> [app\_role\_assignment\_required](#input\_app\_role\_assignment\_required) | value of the app role assignment required | `bool` | `false` | no |
| <a name="input_app_roles"></a> [app\_roles](#input\_app\_roles) | A list of application roles that the application exposes.<br/><br/>Example Usage:<br/><br/>app\_roles = [<br/>  {<br/>    allowed\_member\_types = ["User"]<br/>    description          = "Admins can manage roles and perform all actions."<br/>    display\_name         = "Admin"<br/>    is\_enabled           = true<br/>    value                = "Admin"<br/>  },<br/>  {<br/>    allowed\_member\_types = ["User"]<br/>    description          = "Users can read items."<br/>    display\_name         = "Reader"<br/>    is\_enabled           = true<br/>    value                = "Reader"<br/>  }<br/>] | <pre>list(object({<br/>    allowed_member_types = list(string)<br/>    description          = string<br/>    display_name         = string<br/>    is_enabled           = bool<br/>    value                = string<br/>  }))</pre> | `[]` | no |
| <a name="input_custom_app_name"></a> [custom\_app\_name](#input\_custom\_app\_name) | The name of the application. | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment of the application. | `string` | n/a | yes |
| <a name="input_expose_api"></a> [expose\_api](#input\_expose\_api) | A block defining the API to expose."<br/><br/>  Example Usage:<br/><br/>  expose\_api = [<br/>    {<br/>      type                       = "User"                                                     # The type of the API permission, allowed values are "User" or "Admin"<br/>      value                      = "user\_impersonation"                                       # The value of the API permission<br/>      admin\_consent\_description  = "Allows the app to access the app on your behalf"<br/>      admin\_consent\_display\_name = "Access the app on your behalf"<br/>      user\_consent\_description   = "Allow the application to access the app on your behalf"<br/>      user\_consent\_display\_name  = "Access the app on your behalf"<br/>      enable\_api\_permission      = true                                                       # Enable API permission for the exposed API, default is false<br/>    }<br/>  ] | <pre>list(object({<br/>    type                       = optional(string, "User")<br/>    value                      = optional(string, "user_impersonation")<br/>    admin_consent_description  = optional(string, "Allows the app to access the app on your behalf")<br/>    admin_consent_display_name = optional(string, "Access the app on your behalf")<br/>    user_consent_description   = optional(string, "Allow the application to access the app on your behalf")<br/>    user_consent_display_name  = optional(string, "Access the app on your behalf")<br/>    enable_api_permission      = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_fallback_public_client_enabled"></a> [fallback\_public\_client\_enabled](#input\_fallback\_public\_client\_enabled) | Specifies whether this application is a public client. | `bool` | `false` | no |
| <a name="input_feature_tags"></a> [feature\_tags](#input\_feature\_tags) | A set of feature tags to assign to the application.<br/><br/>Example Usage:<br/><br/>feature\_tags = {<br/>  enterprise = false  # default<br/>  gallery    = false  # default<br/>  hide       = false  # default<br/>} | <pre>object({<br/>    enterprise = optional(bool)<br/>    gallery    = optional(bool)<br/>    hide       = optional(bool)<br/>  })</pre> | `null` | no |
| <a name="input_generate_password"></a> [generate\_password](#input\_generate\_password) | Specifies whether to generate a password for the application. | `bool` | `false` | no |
| <a name="input_group_membership_claims"></a> [group\_membership\_claims](#input\_group\_membership\_claims) | A list of group membership claims that the application requires. | `list(string)` | `[]` | no |
| <a name="input_identifier_uris"></a> [identifier\_uris](#input\_identifier\_uris) | A list of user-defined URIs that uniquely identify an application within its Azure AD tenant. | `set(string)` | `[]` | no |
| <a name="input_known_client_ids"></a> [known\_client\_ids](#input\_known\_client\_ids) | A list of client IDs of known client applications that are allowed to request a token for this application. | `list(string)` | `[]` | no |
| <a name="input_marketing_url"></a> [marketing\_url](#input\_marketing\_url) | The marketing URL of the application. | `string` | `null` | no |
| <a name="input_notes"></a> [notes](#input\_notes) | The notes of the application. | `string` | `"Managed by Terraform"` | no |
| <a name="input_optional_claims"></a> [optional\_claims](#input\_optional\_claims) | A set of optional claims to be returned in the JWTs.<br/><br/>Example Usage:<br/><br/>optional\_claims = {<br/>  id\_token = [<br/>    {<br/>      name                  = "country"<br/>      source                = "user"<br/>      essential             = false<br/>      additional\_properties = []<br/>    }<br/>  ]<br/>  access\_token = [<br/>    {<br/>      name                  = "country"<br/>      source                = "user"<br/>      essential             = false<br/>      additional\_properties = []<br/>    }<br/>  ]<br/>  saml2\_token = [<br/>    {<br/>      name                  = "country"<br/>      source                = "user"<br/>      essential             = false<br/>      additional\_properties = []<br/>    }<br/>  ]<br/>} | <pre>object({<br/>    id_token = optional(list(object({<br/>      name                  = string<br/>      source                = string<br/>      essential             = bool<br/>      additional_properties = list(string)<br/>    })), [])<br/>    access_token = optional(list(object({<br/>      name                  = string<br/>      source                = string<br/>      essential             = bool<br/>      additional_properties = list(string)<br/>    })), [])<br/>    saml2_token = optional(list(object({<br/>      name                  = string<br/>      source                = string<br/>      essential             = bool<br/>      additional_properties = list(string)<br/>    })), [])<br/>  })</pre> | `null` | no |
| <a name="input_owners"></a> [owners](#input\_owners) | A list of object IDs of principals that will be granted ownership of the application. | `list(string)` | n/a | yes |
| <a name="input_privacy_statement_url"></a> [privacy\_statement\_url](#input\_privacy\_statement\_url) | value of the privacy statement url | `string` | `null` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | value of the project name | `string` | n/a | yes |
| <a name="input_public_client"></a> [public\_client](#input\_public\_client) | A block defining the public client configuration. | <pre>object({<br/>    redirect_uris = optional(list(string))<br/>  })</pre> | `null` | no |
| <a name="input_redirect_uris"></a> [redirect\_uris](#input\_redirect\_uris) | A list of redirect URIs for the application. | `list(string)` | `[]` | no |
| <a name="input_service_management_reference"></a> [service\_management\_reference](#input\_service\_management\_reference) | value of the service management reference | `string` | `null` | no |
| <a name="input_sign_in_audience"></a> [sign\_in\_audience](#input\_sign\_in\_audience) | Specifies the Microsoft accounts that are supported for the current application. Possible values are 'AzureADMyOrg', 'AzureADMultipleOrgs', or 'AzureADandPersonalMicrosoftAccount'. | `string` | `"AzureADMyOrg"` | no |
| <a name="input_single_page_application"></a> [single\_page\_application](#input\_single\_page\_application) | A block defining the single-page application configuration.<br/><br/>Example Usage:<br/>single\_page\_application = {<br/>  redirect\_uris = ["https://myapp.com"]<br/>} | <pre>object({<br/>    redirect_uris = optional(list(string))<br/>  })</pre> | `null` | no |
| <a name="input_support_url"></a> [support\_url](#input\_support\_url) | value of the support url | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | value of the tags | `set(string)` | `[]` | no |
| <a name="input_template_id"></a> [template\_id](#input\_template\_id) | The ID of the application template. | `string` | `null` | no |
| <a name="input_terms_of_service_url"></a> [terms\_of\_service\_url](#input\_terms\_of\_service\_url) | value of the terms of service url | `string` | `null` | no |
| <a name="input_update_key_vault"></a> [update\_key\_vault](#input\_update\_key\_vault) | The ID of the key vault to store the application password, The keyvault must exist in the same subscription and region as the original provider block.<br/><br/>Example Usage:<br/><br/>update\_key\_vault = {<br/>  keyvault\_name       = "mykeyvault"            # The name of the key vault<br/>  resource\_group\_name = "myresourcegroup"       # The name of the resource group, The resource group must be in the same provider subscription as the root module<br/>} | <pre>object({<br/>    keyvault_name       = string<br/>    resource_group_name = string<br/>  })</pre> | `null` | no |
| <a name="input_web"></a> [web](#input\_web) | A block defining the web configuration. | <pre>object({<br/>    redirect_uris = optional(list(string))<br/>    home_page_url = optional(string, null)<br/>    logout_url    = optional(string, null)<br/>    implicit_grant = optional(object({<br/>      access_token_issuance_enabled = optional(bool, false)<br/>      id_token_issuance_enabled     = optional(bool, true)<br/>    }), {})<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_name"></a> [app\_name](#output\_app\_name) | n/a |
| <a name="output_client_id"></a> [client\_id](#output\_client\_id) | n/a |
| <a name="output_client_secret"></a> [client\_secret](#output\_client\_secret) | n/a |
<!-- END_TF_DOCS --># terraform-azure-entra-application-v1
