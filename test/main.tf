# Test service principal
module "service-principal_object_idz" {
  source            = "../"
  owners            = ["vimal.vijayan@essity.com"]
  environment       = "dev"
  project_name      = "test"
  app_name          = "terraform"
  generate_password = true
  tags              = ["owner: vimal.vijayan@essity.com"]
  expose_api = [{
    value                 = "user_impersonation"
    enable_api_permission = true
  }]
  api_permissions = [{
    resource_app = "MicrosoftGraph"
    resource_access = [{
      id   = "User.Read.All"
      type = "Role"
    }]
    },
    {
      resource_app = "DynamicsCrm"
      resource_access = [{
        id   = "78ce3f0f-a1ce-49c2-8cde-64b5c0896db4"
        type = "Scope"
      }]
    }
  ]
}
